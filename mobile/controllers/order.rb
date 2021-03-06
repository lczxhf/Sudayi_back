SudayiBack::Mobile.controllers :order do
use Rack::Cors do 
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

post :create_order, :csrf_protection=>false do
    if params[:cart]
       @account = CourierAccount.find('55094e654c31dc6fec000007')  #找到配送商,这里因为没有,所以填了一个固定的
       if @account.courier_employees.where(is_work:true).first                 #找到配商的正在上班的快递员
          node = @account.courier_address.node._id                                      #获取配送商所在的区
          cart_arr = params[:cart].split(',')
          carts = []                          #存购物车对象的数组
      
          real_store = []      #存在把公司作为始发点的话,怎样的路线花费的时间最短
          work_store={}       #存身上有单的快递员在完成了订单后送去客户,怎样的路线花费的时间最短
          end_node={}                   #快递员最后一张单结束时的所在区
          stores=[]                             #中间变量
          stores_hash={}
          cart_hash={}
          cart_arr.each do |cart_id|
               cart = Cart.find(cart_id)                                        #获取客户要购买的购物车对象 把它们加入数组
               carts<<cart
               product_stores=cart.product_detail.product_stores                 #获取此规格商品在什么仓库下有货
             product_stores.dup.each_with_index do |product_store,index|   #循环以上的仓库
                    if product_stores.size==1         #判断是不是只有一个仓库                         
                          if !product_store.store.is_open                                           #判断仓库是否开门了
                                render :html,"#{cart.product_detail.product.name}商品所在仓库没有开门"
                          end
                          if product_store.amount-product_store.reserve<=0     
                                render :html,"#{cart.product_detail.product.name}没有库存了"
                          end
                          if cart.product_details
                                cart.product_details.each do |a|
                                  bring_3=ProductStore.where(store_id:product_store.store._id,product_detail_id:a).first
                                  if bring_3
                                      if bring_3.amount-bring_3.reserve<=0
                                          render :html,"#{cart.product_detail.product.name}买一携三失败，同一仓库没有存货"
                                      end
                                  else
                                      render :html,"#{cart.product_detail.product.name}买一携三失败，同一仓库没有存货"
                                  end 
                                end
                          end
                    else
                          if !product_store.store.is_open
                                product_stores.delete(product_store)
                                next
                          end
                          if product_store.amount-product_store.reserve<=0
                                product_stores.delete(product_store)
                                next
                          end
                          if cart.product_details
                                cart.product_details.each do |a|
                                  bring_3=ProductStore.where(store_id:product_store.store._id,product_detail_id:a).first
                                  if bring_3
                                      if bring_3.amount-bring_3.reserve<=0
                                          product_stores.delete(product_store)
                                          return
                                      end
                                  else
                                      product_stores.delete(product_store)
                                      return
                                  end 
                                end
                          end
                    end
               end
               if product_stores.size==1
                      stores<<product_stores[0]                                          #把仓库加到暂存变量
               else
                      stores<<product_stores                                                                    #把仓库数组加到暂存变量
               end
          end

          stores.dup.each_with_index do |store,index|
                if store.class.name=='Array'                                                         #判断暂存变量里的某一个元素是不是数组
                      is_add=false
                      
                      store.each_with_index do |arr,arr_index|
                            if !stores.include?(arr)                                              #判断数组里的仓库和暂存变量里的仓库有没有相同
                                  
                                  stores.each do |a|
                                    if a.class.name!="Array"
                                        if a.store_address.node._id==arr.store_address.node._id    #判断数组里的仓库的所在区有没有和暂存变量里的仓库的所在区相同
                                                stores[index]=arr
                                                is_add=true
                                                return
                                        end
                                    end
                                  end
                            else
                                    cart_arr[stores.index(arr)]+=",#{cart_arr[index]}"
                                    cart_arr[index]=nil
                                    stores[index]=nil
                                    is_add=true
                            end
                            if is_add                                                               #判断数组里的仓库有没有被加到store_nodes里
                                   return
                            end
                      end
                else
                      if index!=0
                            index.downto(1) do |a|
                                  if store==stores[a-1]
                                        stores[index]=nil
                                        cart_arr[a-1]+=",#{cart_arr[index]}"
                                        cart_arr[index]=nil
                                        return
                                  end
                            end
                      end
                end
               
          end
          stores=stores.compact
          cart_arr=cart_arr.compact
          customer_node=carts[0].customer_account.address.node._id   #获取客户所在的区

          if stores.size==1                               #判断这张订单是不是只需要去一个仓库
              real_store << NodeWay.where(node_id:node,tonode:stores[0].address.node._id).first.time+NodeWay.where(node_id:stores[0].address.node._id,tonode:customer_node).first.time
              real_store << stores[0]
              real_store << customer_node
              cart_hash["company"]=cart_arr
              
          else
              real_store,a = CourierOrder.get_node_time(stores.dup,node,cart_arr.dup,customer_node)
              cart_hash["company"]=a
          end

          # 以下是计算身上有接单的快递员去派送此单所需的时间
          employees = @account.courier_employees.where(is_work:true,isfree:false)
          temp_store=[]
          employees.each_with_index do |employee,index|
                    courier_order=employee.courier_orders.desc(:level).first
                    if courier_order.back_order               #判断快递员是否正在回公司路上
                        middle_time=((courier_order.back_order.created_at+courier_order.back_order.usetime.minute).to_i-Time.now.to_i)/60
                        temp_store=real_store.dup
                        temp_store[0]+=middle_time
                        work_store[index]=temp_store
                        temp_store=[]
                        end_node<<node._id
                        cart_hash[index]=cart_hash["company"]
                        #stores_hash[index]=stores_hash["company"].dup
                        next
                    else
                        order=courier_order.orders.desc(:level).first
                        end_node<<order.end_node._id
                    end
                      if stores.size==1
                            temp_store << NodeWay.where(node_id:end_node[index],tonode:stores[0].store_address.node._id).first.time+NodeWay.where(node_id:stores[0].store_address.node._id,tonode:customer_node).first.time+(employee.whenfree.to_i-Time.now.to_i)/60
                            temp_store << stores[0]
                            temp_store << customer_node
                            if stores[0].store_address.node._id==end_node[index]
                                temp_store << "相同区"
                            end
                            cart_hash[index]=cart_arr
                      else
                          temp_store,b = CourierOrder.get_node_time(store_nodes.dup,end_node[index],cart_arr.dup,customer_node)
                          temp_store[0]+=(employee.whenfree.to_i-Time.now.to_i)/60
                          if end_node[index]==temp_store[1]
                            temp_store<<"相同区"
                          end
                           cart_hash[index]=b
                      end
                    work_store[index]=temp_store
                    temp_store=[]
          end
          #判断各个快递员送此订单所需的时间,得到最快的
          courier_index=-1
          middle_var=real_store[0]
          courier_middle_var=11111111
          courier_index_2=0
          work_store.each do |key,value|       #循环判断是在公司起送快还是正在派送商品的快递员派送此单快
                real_time=value[0]
                if value.include?('相同区')
                  real_time=value[0]-30
                  value.pop
                end
                if real_time<middle_var
                      courier_index=key
                      middle_var=real_time
                end
                if real_time<courier_middle_var
                    courier_index_2=key
                end
          end
          if courier_index==-1       #courier_index如果是-1就代表在公司起送比较快
             real_courier=@account.courier_employees.where(is_work:true,isfree:true).first
                if  real_courier  #判断配送商是否有正在待命的快递员
                      CourierOrder.create_order(real_store,real_courier._id,@account._id,carts,node,cart_hash["company"])
                else
                      real_courier=employee[courier_index_2]
                      CourierOrder.create_order(work_store[courier_index_2],real_courier._id,@account._id,carts,end_node[courier_index_2],cart_hash[courier_index_2])
                end
          else
                real_courier=employee[courier_index]
                CourierOrder.create_order(work_store[courier_index],real_courier._id,@account._id,carts,end_node[courier_index],cart_hash[courier_index])
          end
       else
            "快递员还没上班".to_json
       end
    else
        "请选择购买的商品".to_json
    end
end
  

end
