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
          store_nodes = []              #暂存要去的仓库的node_id数组
          real_store_nodes = []      #存在把公司作为始发点的话,怎样的路线花费的时间最短
          work_store_nodes={}       #存身上有单的快递员在完成了订单后送去客户,怎样的路线花费的时间最短
          end_node={}                   #快递员最后一张单结束时的所在区
          stores=[]                             #中间变量
          store_ids=[]
          stores_hash={}
          cart_hash={}
          cart_arr.each do |cart_id|
               cart = Cart.find(cart_id)                                        #获取客户要购买的购物车对象 把它们加入数组
               carts<<cart

               product_stores=cart.product_detail.product_stores                 #获取此规格商品在什么仓库下有货
               product_stores.dup.each_with_index do |product_store,index|   #循环以上的仓库
                      if product_stores.size==1                                                         #判断是不是只有一个仓库
                            if !product_store.store.is_open                                           #判断仓库是否开门了
                                  render :html,"#{Cart.find(cart_id).product_detail.product.name}商品所在仓库没有开门"
                            end
                      else
                            if !product_store.store.is_open
                                  product_stores.delete(product_store)
                            end
                      end
               end
               
               if product_stores.size==1
                      stores<<product_stores[0]                                          #把仓库加到暂存变量
               else
                      arr=[]
                      product_stores.each do |product_store|
                            arr<<product_store
                      end
                      stores<<arr                                                                    #把仓库数组加到暂存变量
               end
          end
          stores.uniq                                                                                 #删除暂存变量里相同的仓库
          stores.dup.each_with_index do |store,index|
                if store.class.name=='Array'                                                         #判断暂存变量里的某一个元素是不是数组
                      is_add=false
                      store_arr=[]
                      store.each_with_index do |arr,arr_index|
                            if !stores.include?(arr)                                              #判断数组里的仓库和暂存变量里的仓库有没有相同
                                  store_arr<<arr.store_address.node._id
                                  stores.each do |a|
                                    if a.class.name!="Array"
                                        if a.store_address.node._id==arr.store_address.node._id    #判断数组里的仓库的所在区有没有和暂存变量里的仓库的所在区相同
                                                store_nodes<<arr.store_address.node._id
                                                #stores[index]=arr
                                                store_ids<<arr._id
                                                is_add=true
                                                return
                                        end
                                    end
                                  end
                                  if is_add                                                               #判断数组里的仓库有没有被加到store_nodes里
                                        return
                                  end
                            else
                                    #stores.delete(store)
                                    cart_arr[stores.index(arr)]+=",#{cart_arr[index]}"
                                    cart_arr.delete_at(index)
                                    is_add=true
                                    return
                            end
                      end
                      if !is_add                                                                        
                            store_nodes<<store_arr                                        #如果没添加就把仓库所在区数组加到store_nodes里
                            store_ids<<store.collection{|q| q._id}
                      end
                else
                      store_nodes<< store.store_address.node._id
                      store_ids<<store._id
                end
               
          end
          customer_node=carts[0].customer_account.address.node._id   #获取客户所在的区
          store_nodes<<customer_node
          if store_nodes.size==2                               #判断这张订单是不是只需要去一个仓库
              real_store_nodes << NodeWay.where(node_id:node,tonode:store_nodes[0]).first.time+NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
              real_store_nodes << store_nodes[0]
              real_store_nodes<<customer_node
              #stores_hash["company"]=stores
          else
              real_store_nodes,a = CourierOrder.get_node_time(store_nodes.dup,node,cart_arr.dup)
              cart_hash["company"]=a
              #stores_hash["company"]=a
              #real_store_nodes[0]+=NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
          end

          # 以下是计算身上有接单的快递员去派送此单所需的时间
          employees = @account.courier_employees.where(is_work:true,isfree:false)
          temp_store_nodes=[]
          employees.each_with_index do |employee,index|
                    courier_order=employee.courier_orders.desc(:level).first
                    if courier_order.back_order               #判断快递员是否正在回公司路上
                        middle_time=((courier_order.back_order.created_at+courier_order.back_order.usetime.minute).to_i-Time.now.to_i)/60
                        temp_store_nodes=real_store_nodes.dup
                        temp_store_nodes[0]+=middle_time
                        work_store_nodes[index]=temp_store_nodes
                        temp_store_nodes=[]
                        end_node<<node._id
                        cart_hash[index]=cart_hash["company"]
                        #stores_hash[index]=stores_hash["company"].dup
                        next
                    else
                        order=courier_order.orders.desc(:level).first
                        end_node<<order.end_node._id
                    end
                      if store_nodes.size==2
                            temp_store_nodes << NodeWay.where(node_id:end_node[index],tonode:store_nodes[0]).first.time+NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time+(employee.whenfree.to_i-Time.now.to_i)/60
                            temp_store_nodes << store_nodes[0]
                            temp_store_nodes << customer_node
                            if store_nodes[0]==end_node[index]
                                temp_store_nodes << "相同区"
                            end
                            #stores_hash[index]=stores
                            cart_hash[index]=cart_arr
                      else
                          temp_store_nodes,b = CourierOrder.get_node_time(store_nodes.dup,end_node[index],cart_arr.dup)
                          temp_store_nodes[0]+=NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time+(employee.whenfree.to_i-Time.now.to_i)/60
                          if end_node[index]==temp_store_nodes[1]
                            temp_store_nodes<<"相同区"
                          end
                           #stores_hash[index]=b
                           cart_hash[index]=b
                      end
                    work_store_nodes[index]=temp_store_nodes
                    temp_store_nodes=[]
          end
          #判断各个快递员送此订单所需的时间,得到最快的
          courier_index=-1
          middle_var=111111111111
          courier_index_2=0
          work_store_nodes.each do |key,value|       #循环判断是在公司起送快还是正在派送商品的快递员派送此单快
                real_time=value[0]
                if value.include?('相同区')
                  real_time=value[0]-30
                  value.pop
                end
                if real_time<real_store_nodes[0]
                  courier_index=key
                end
                if real_time<middle_var
                      middle_var=real_time
                      courier_index_2=key
                end
          end
          if courier_index==-1       #courier_index如果是-1就代表在公司起送比较快
             real_courier=@account.courier_employees.where(is_work:true,isfree:true).first
                if  real_courier  #判断配送商是否有正在待命的快递员
                      CourierOrder.create_order(real_store_nodes,real_courier._id,@account._id,carts,node,cart_hash["company"])
                else
                      real_courier=employee[courier_index_2]
                      CourierOrder.create_order(work_store_nodes[courier_index_2],real_courier._id,@account._id,carts,end_node[courier_index_2],cart_hash[courier_index_2])
                end
          else
                real_courier=employee[courier_index]
                CourierOrder.create_order(work_store_nodes[courier_index],real_courier._id,@account._id,carts,end_node[courier_index],cart_hash[courier_index])
          end
       else
            "快递员还没上班".to_json
       end
    else
        "请选择购买的商品".to_json
    end
end
  

end
