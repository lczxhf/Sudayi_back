class CourierOrder
  include Mongoid::Document
  include Mongoid::Timestamps 
  #快递员订单表

  has_many :carts
  belongs_to :courier_employee                                              #订单的快递员id
  has_many :orders   
  has_one :back_order
  belongs_to :error_info
  
  field :number,:type=>String                                                     #订单号
  field :iscomplete,:type=>Boolean,:default=>false                #订单是否完成
  field :isnow,:type=>Boolean,:default=>false                         #订单是否正在执行
  field :usetime,:type=>Integer,:default=>''                              #完成订单预计使用时间
  field :level,:type=>Integer,:default=>0                                    #订单的等级
 

 def self.get_node_time(stores,node,cart_arr,customer_node)                 #获取从某个区到n个仓库的最快路线
      first_node = node
      new_store=[]
      new_store<<0
      new_cart=[]
      a=stores.size
      (a-1).times do 
          time=111111111111
          node_index=0
          arr_index=-1
          stores.dup.each_with_index do |store,index|
              if store.class.name=='Array'
                    store_time=[]
                    store.each_with_index do |arr,index_arr|
                          node_way = NodeWay.where(node_id:first_node,tonode:arr.store_address.node._id).first.time
                          time,arr_index,node_index = node_way,index_arr,index if node_way < time
                         
                    end
              else
                      node_way = NodeWay.where(node_id:first_node,tonode:store.store_address.node._id).first.time
                      time = node_way if node_way < time
                      node_index = index if node_way < time
                      arr_index=-1
              end
          end

          if arr_index!=-1
                stores[node_index]=stores[node_index][arr_index]
                arr_index=-1
          end
          new_store<<stores[node_index]
          new_store[0]+=time
          new_cart<<cart_arr[node_index]
          first_node = stores[node_index].store_address.node._id
          stores.delete(store_node)
      end
      new_store[0]+=NodeWay.where(node_id:new_store.last,tonode:stores[0].store_address.node._id).first.time+NodeWay.where(node_id:stores[0].store_address.node._id,tonode:customer_node).first.time
      new_store<<stores[0]
      new_store<<customer_node
      return new_store,new_cart
 end

#生成订单表
def self.create_order(courier_store,employee_id,courier_account,carts,first_node,cart_arr)                                                #创建订单
      courier_order=CourierOrder.new   
      employee=CourierEmployee.find(employee_id)   #获取快递员
      setting=OrderSetting.where(courier_account_id:courier_account).first #得到某个配送公司的时间设置表
      number=(Order.count+1).to_s          　　　　　　　#随机生成订单号
      if number.length<6
          (6-number.length).times do
              number='0'+number
          end
      end
      courier_order.number=number
      courier_order.usetime=courier_store[0]+OrderSetting.base_time(courier_account)+(courier_nodes.size-2)*setting.store_vali_time
      courier_order.level=employee.courier_orders.max(:level)+1
      if courier_order.level==1
            courier_order.isnow=true
      else
        courier_order.usetime+=setting.customer_vali_time
      end
      courier_order.courier_employee=employee
      courier_order.build_order_time(store_time:[courier_store.size-2])
      other_time=0
      courier_store.each_with_index do |store,index|
           if index==0||index==courier_store.size-1
                  next
           else
                  order=Order.new
                  order.level=index
                  order.end_node=store.store_address.node._id
                  order.order_type="取"
                  if index==1
                     order.usetime=NodeWay.where(node_id:first_node,tonode:store.store_address.node._id).first.time+setting.store_time+setting.store_vali_time+setting.order_interval
                     order.first_node=first_node
                     
                  else
                      order.usetime=NodeWay.where(node_id:courier_store[index-1].store_address.node._id,tonode:store.store_address.node._id).first.time+setting.store_vali_time
                      order.first_node=courier_store[index-1].store_address.node._id
                   end
                   other_time+=order.usetime
                   carts.each_with_index do |cart,cart_index|
                        if cart_arr[index].include?(cart._id)
                            pd_array=[]
                            sum_array=[]
                            pd_array<<cart.product_detail._id
                            sum_array<<cart.sum
                            if cart.product_detail.nil?
                               pd_array+=cart.product_detail
                            end
                            order.product_detail<<pd_array
                            order.sum<<sum_array
                            product_store=cart.product_detail.product_stores.where(store_id:store._id).first
                            product_store.reserve+=cart.sum
                            product_store.save
                            point=ProductPoint.where(courier_account_id:courier_account,product_id:cart.product_detail.product._id).first
                            if  point
                                  order.discount<<point.discount
                            else
                                  order.discount<<1
                            end
                        end
                   end
                   order.save
           end
      end
      send_order=Order.new
      send_order.level=courier_store.size
      send_order.first_node=courier_store[-2].store_address.node._id
      send_order.end_node=courier_store.last
      send_order.order_type="送"
      send_order.usetime=courier_order.usetime-other_time
      carts.each do |cart|
          send_order.product_detail<<cart.product_detail
          send_order.sum<<cart.sum
          if cart.coupon
                send_order.discount<<cart.coupon
          else
                send_order.discount<<1
          end
      end
      courier_order.save
      send_order.save
      if employee.isfree
            employee.isfree=false
            employee.whenfree=Time.now+courier_order.usetime.minute+setting.customer_vali_time.minute
      else
            employee.whenfree+=courier_order.usetime.minute+setting.customer_vali_time.minute
      end
      employee.save
      return courier_order.usetime
end


end
