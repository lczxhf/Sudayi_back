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
       @account = CourierAccount.find('55094e654c31dc6fec000007')
       if @account.courier_employees.where(is_work:true).first
          node = @account.courier_address.node._id
          cart_arr = params[:cart].split(',')
          carts = []                          #存购物车对象的数组
          store_nodes = []              #暂存要去的仓库的node_id数组
          real_store_nodes = []      #存在把公司作为始发点的话,怎样的路线花费的时间最短
          work_store_nodes={}       #存身上有单的快递员在完成了订单后送去客户,怎样的路线花费的时间最短
          end_node={}                   #快递员最后一张单结束时的所在区
          cart_arr.each do |cart_id|
               carts<<cart = Cart.find(cart_id)                                        #获取客户要购买的购物车对象 把它们加入数组
               stores<<cart.product_detail.product_store.store
               if !cart.product_detail.product_store.store.is_open
                  render :html,"#{Cart.find(cart_id).product_detail.product.name}商品所在仓库没有开门"
               end
               stores.uniq
               stores.each do |store|
                        store_nodes<< store.store_address.node._id
                    end
            end
          customer_node=carts[0].customer_account.address.node._id
          if store_nodes.size==1                               #判断这张订单是不是只需要去一个仓库
              real_store_nodes << NodeWay.where(node_id:node,tonode:store_nodes[0]).first.time+NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
              real_store_nodes << store_nodes[0]
          else
              real_store_nodes = CourierOrder.get_node_time(store_nodes,node)
              real_store_nodes[0]+=NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
          end

          # 以下是计算身上有接单的快递员去派送此单所需的时间
          employees = @account.courier_employees.where(is_work:true,isfree:false)
          temp_store_nodes=[]
          employees.each_with_index do |employee,index|
                    courier_order=employee.courier_orders.desc(:level).first
                    if courier_order.back_order               #判断快递员是否正在回公司路上
                        middle_time=((courier_order.back_order.created_at+courier_order.back_order.usetime.minute).to_i-Time.now.to_i)/60
                        temp_store_nodes=real_store_nodes
                        temp_store_nodes[0]+=middle_time
                        work_store_nodes[index]=temp_store_nodes
                        temp_store_nodes=[]
                        end_node<<node._id
                        next
                    else
                        order=courier_order.orders.desc(:level).first
                        end_node<<order.end_node._id
                    end
                      if store_nodes.size==1
                            temp_store_nodes << NodeWay.where(node_id:end_node[index],tonode:store_nodes[0]).first.time+NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
                            temp_store_nodes << store_nodes[0]
                            if store_nodes[0]==end_node[index]
                                temp_store_nodes << "相同区"
                            end
                      else
                          temp_store_nodes = CourierOrder.get_node_time(store_nodes,end_node[index])
                          temp_store_nodes[0]+=NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
                          if end_node[index]==temp_store_nodes[1]
                            temp_store_nodes<<"相同区"
                          end
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
                      CourierOrder.create_order(real_store_nodes,real_courier._id,@account._id,carts,node,customer_node)
                else
                      real_courier=employee[courier_index_2]
                      CourierOrder.create_order(work_store_nodes[courier_index_2],real_courier._id,@account._id,carts,end_node[courier_index_2],customer_node)
                end
          else
                real_courier=employee[courier_index]
                CourierOrder.create_order(work_store_nodes[courier_index],real_courier._id,@account._id,carts,end_node[courier_index],customer_node)
          end
       else
            "快递员还没上班".to_json
       end
    else
        "请选择购买的商品".to_json
    end
end
  

end
