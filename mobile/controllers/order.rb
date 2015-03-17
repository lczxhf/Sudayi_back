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
       @account = CourierAccount.find('54d4819fcc3007823d000001')
       if @account.courier_employees.where(is_work:true).first
          node = @account.courier_address.node
          cart_arr = params[:cart].split(',')
          carts = []                          #存购物车对象的数组
          store_nodes = []              #暂存要去的仓库的node_id数组
          real_store_nodes = []
          courier_time = 0              #存公司出发到仓库再到客户的时间
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
          customer_node = carts[0].customer_account.address.node._id          #存客户的node_id
          if store_nodes.size==1                               #判断这张订单是不是只需要去一个仓库
              courier_time = NodeWay.where(node_id:node._id,tonode:store_nodes[0]).first.time+NodeWay.where(node_id:store_nodes[0],tonode:customer_node).first.time
          else
              first_node = customer_node
              real_store_nodes<<0
              (store_nodes.size - 1).times do
                 time = 11111111111          #暂存数组中的node到某一个node的最短时间
                 node_index = 0                    #暂存哪个最短时间的node的索引  
                 store_nodes.each_with_index do |node,index|
                        node_way = NodeWay.where(node_id:first_node,tonode:node).first.time
                        time = node_way if node_way < time
                        node_index = index if node_way < time
                    end
                    real_store_nodes<<store_nodes[node_index]
                    real_store_nodes[0]+=time
                    first_node = store_nodes[node_index]
             end
          end
          employees = @account.courier_employees.where(is_work:true,isfree:false)
          employees.each do |employee|
                    courier_order=employee.courier_orders.desc(:level).first
                  
              end
       else
            "快递员还没上班".to_json
       end
    else
        "请选择购买的商品".to_json
    end
end
  

end
