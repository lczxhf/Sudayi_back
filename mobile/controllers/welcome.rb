SudayiBack::Mobile.controllers :welcome do
 #  use Rack::Cors do
 #  allow do
 #    # put real origins here
 #    origins '*', 'null'
 #    # and configure real resources here
 #    resource '*', :headers => :any, :methods => [:get, :post, :options]
 #  end
 # end 

#返回所有图片
   get :all_pics do
    @image_items = ImageItem.all.order_by(:created_at.desc)
    @image_items.to_json
  end

#返回已被加入仓库的商品
    get :get_pics_a do
        @products=[]
        ProductStore.all.each do |product_store|
                if !@products.include?(product_store.product_detail.product)
                    @products<<product_store.product_detail.product
                end
        end

    @products.to_json(:include=>{:image_items=>{:only=>[:url]},:product_details=>{:only=>[:price,:storage,:reserve,:specification]}})
 end


 get :home_pic do
    if !params[:page]
        page=1
    else
        page=params[:page].to_i
    end
    size=10
    product_cache=ProductCache.where(node_id:params[:node_id],:created_at.gt=>Time.now-5.minute).first
    if !product_cache
        address=CourierAddress.where(node_id:params[:node_id]).first  #need to revamp
        account=CourierAccount.where(courier_address_id:address._id,level:1).first
        nodes=[]
        nodes<<params[:node_id]
        employees=account.courier_employees.where(is_work:true,isfree:false)
        employees+=account.courier_employees.where(is_work:true,isfree:true).ne(:end_node=>"")
        employees.each do |employee|
            if employee.courier_orders.where(isnow:true).first
                courier_order=employee.courier_orders.desc(:level).first
                if !courier_order.back_order
                    nodes<<courier_order.orders.desc(:level).first.end_node
                end
            else
                nodes<<employee.end_node
            end
        end
        nodes.uniq!
        nodes.sort_by!{|node| NodeWay.where(node_id:node,tonode:params[:node_id]).first.time}
        stores=nodes.collect do |node|
            store_address=StoreAddress.where(node_id:node).collect{|a| a._id}
            logger.info store_address.inspect
            abc=Store.in(:store_address_id=>store_address).where(is_open:true)  
            logger.info abc.to_json
            abc
        end 
        product_result=[]
        product_cache=ProductCache.new
        product_cache.node_id=params[:node_id]
        logger.info stores.to_json
        stores.each do |store|

            # if store.class.name=="Array"
                store.each do |a|
                    ProductStore.where(store_id:a._id,:amount.gt=>0,is_up_shelve:true).each do |b|
                        if b.amount-b.reserve>0
                            product_result<<b.product_detail.product
                            product_result.uniq!
                            if product_result.size>=page*size
                                render :html,product_result.to_json(:include=>{:image_items=>{:only=>[:url]},:product_details=>{:only=>[:price,:storage,:reserve,:specification]}})
                            end
                        end
                    end
                     
                end
            # else
            #     ProductStore.where(store_id:store._id,:amount.gt=>0,is_up_shelve:true).each do |b|
            #         if b.amount-b.reserve>0
            #             product_result<<b.product_detail.product
            #             product_result.uniq!
            #             if product_result.size>=page*size
            #                  render :html,product_result.to_json
            #             end
            #         end
            #     end
            # end
        end
        product_result.to_json(:include=>{:image_items=>{:only=>[:url]},:product_details=>{:only=>[:price,:storage,:reserve,:specification]}})
    else
        arr=product_cache.name.split(",")
        page*size
        
    end
 end

end
