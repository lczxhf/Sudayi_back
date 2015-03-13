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
                @products<<product_store.product_collection.product
        end
    @products.to_json(:include=>{:image_items=>{:only=>[:url]},:product_details=>{:only=>[:price,:storage,:specification]}})
 end

end
