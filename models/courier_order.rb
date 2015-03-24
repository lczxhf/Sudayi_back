class CourierOrder
  include Mongoid::Document
  include Mongoid::Timestamps 
  #快递员订单表

  has_many :carts
  belongs_to :courier_employee                                              #订单的快递员id
  has_many :orders   
  has_one :back_order
  
  field :number,:type=>String                                                     #订单号
  field :iscomplete,:type=>Boolean,:default=>false                #订单是否完成
  field :isnow,:type=>Boolean,:default=>false                         #订单是否正在执行
  field :usetime,:type=>Integer,:default=>''                              #完成订单预计使用时间
  field :level,:type=>Integer,:default=>0                                    #订单的等级
 

 def self.get_node_time(store_nodes,node,stores)                 #获取从某个区到n个仓库的最快路线
      first_node = node
      new_store_nodes=[]
      new_store_nodes<<0
      store_nodes.size.times do 
          time=111111111111
          node_index=0
          arr_index=-1
          store_nodes.each_with_index do |store_node,index|
              if store_node.class.name=='Array'
                    store_time=[]
                    store_node.each_with_index do |arr,index_arr|
                          node_way<< NodeWay.where(node_id:first_node,tonode:arr).first.time
                          time = node_way if node_way < time
                          arr_index = index_arr if node_way < time
                    end
                    if arr_index!=-1
                          node_index=index
                    end
              else
                      node_way = NodeWay.where(node_id:first_node,tonode:store_node).first.time
                      time = node_way if node_way < time
                      node_index = index if node_way < time
              end
          end
          if arr_index!=-1
                real_node=store_nodes[node_index][arr_index]
                stores[node_index]=stores[node_index][arr_index]
                store_nodes[node_index]=real_node
                arr_index=-1
          end
          new_store_nodes<<store_nodes[node_index]
          new_store_nodes[0]+=time
          first_node = store_nodes[node_index]
          store_nodes.delete_at(node_index)
      end
      return new_store_nodes
 end

#生成订单表
def self.create_order(courier_nodes,employee_id,courier_account,carts,first_node,stores)                                                #创建订单
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
      courier_order.usetime=courier_nodes[0]+OrderSetting.base_time(courier_account)+(courier_nodes.size-2)*setting.store_vali_time
      courier_order.level=employee.courier_orders.max(:level)+1
      if courier_order.level==1
            courier_order.isnow=true
      end
      courier_order.courier_employee=employee
      other_time=0
      courier_nodes.each_with_index do |node,index|
           if index==0
                  next
           else
                  order=Order.new
                  order.level=index
                  order.end_node=node
                  order.order_type="取"
                  if index==1
                     order.usetime=NodeWay.where(node_id:first_node,tonode:node).first.time+setting.store_time+setting.store_vali_time+setting.order_interval
                     order.first_node=first_node
                  else
                      order.usetime=NodeWay.where(node_id:courier_nodes[index-1],tonode:node).first.time+setting.store_vali_time
                      order.first_node=courier_nodes[index-1]
                   end
                   other_time+=order.usetime
                   carts.each_with_index do |cart,cart_index|
                        if cart.product_detail.product_store.store.node==node
                            order.product_detail<<cart.product_detail._id
                            order.sum<<cart.sum

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
      send_order.level=courier_nodes.size
      send_order.first_node=courier_nodes.last
      send_order.end_node=carts.first.customer_account.address.node._id
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
