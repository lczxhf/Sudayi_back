SudayiBack::MobileAdmin.controllers :product_upload do
 use Rack::Cors do
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end 
  
#供应商上传商品
post :create_product, :csrf_protection=>false do
   if params[:ck_name] && params[:ck_des] && params[:cd_price] && params[:spec] && params[:cd_storage] && params[:ck_uploadkey1]
    if !Product.where(supplier_account_id:params[:user_id],name:params[:ck_name]).first    #判断商品名是否存在
     if !params[:ck_price].to_f<=0.0 && !params[:ck_storage].to_i<=0                                            #判断输入的价格和价钱是否小于0
      @product = Product.new()
      @product.name = params[:ck_name]
      @product.account_id = params[:user_id]
      @product.description = params[:ck_des]
      state = State.where(code:'01').first
      @product.state = state
      product_detail = ProductDetail.new
      product_detail.price = params[:ck_price].to_f
      product_detail.product = @product
      product_detail.specification = params[:ck_spec]
      product_detail.storage = params[:ck_storage].to_i
      product_detail.no_store = params[:ck_storage].to_i
      product_detail.save
  #   @product.store=Store.create()
        if params[:uploadkey1]
          image_item = ImageItem.new
          image_item.url = params[:uploadkey1]
          @product.image_items<<image_item
          image_item.save!
        end
        if params[:uploadkey2]
          image_item = ImageItem.new
          image_item.url = params[:uploadkey2]
          @product.image_items<<image_item
          image_item.save!
        end
        if params[:uploadkey3]
          image_item = ImageItem.new
          image_item = ImageItem.new
          image_item.url = params[:uploadkey3]
          @product.image_items<<image_item
          image_item.save!
        end
        if params[:uploadkey4]
          image_item = ImageItem.new
          image_item.url = params[:uploadkey4]
          @product.image_items<<image_item
          image_item.save!
        end
        if params[:uploadkey5]
          image_item = ImageItem.new
          image_item.url = params[:uploadkey5]
          @product.image_items<<image_item
          image_item.save!
        end
    @product.save!
     else
  "请正确填写价格和库存".to_json
     end
    else
  "商品名已存在".to_json
    end
   else
  "请将信息填写完整".to_json
   end
 end

 #获取某一个供应商里所有没加入仓库的商品
get :warehouse_all_product do
  if params[:user_id]
     product_details = ProductDetail.where(:no_store.gt=>0)
     products = []
     product_details.each do |product_detail|
     if Product.where(account_id:params[:user_id],:_id=>product_detail.product._id).first
       products<<product_detail.product
     end
    end
     products.to_json(:include=>:product_details)
  else
     '用户不存在'.to_json
  end
end

end



