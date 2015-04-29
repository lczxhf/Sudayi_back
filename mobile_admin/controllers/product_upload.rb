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
  logger.info params
   if params[:ck_name] && params[:ck_des] && params[:ck_price] && params[:ck_spec] && params[:ck_storage] && params[:url1]
    if !Product.where(supplier_account_id:params[:user_id],name:params[:ck_name]).first    #判断商品名是否存在

     if !(params[:ck_price].to_f<0.0) && !(params[:ck_storage].to_i<0)                                            #判断输入的价格和价钱是否小于0
      @product = Product.new()
      @product.name = params[:ck_name]
      @product.supplier_account_id = params[:user_id]
      @product.description = params[:ck_des]
      state = State.where(code:'01').first
      @product.state = state
      @product.number=params[:number]
      if params[:is_bring_three]=="true"
        @product.is_bring_three=true
      else
        @product.is_bring_three=false
      end
      bill=Bill.where(name:params[:bill]).first
      @product.bill=bill
      
      product_detail = ProductDetail.new
      product_detail.price = params[:ck_price].to_f
      product_detail.product = @product
      product_detail.specification = params[:ck_spec]
      product_detail.storage = params[:ck_storage].to_i
      product_detail.no_store = params[:ck_storage].to_i
      product_detail.save
      case params[:url_sum]
      when "3"
        @product.level=1
      when "2"
        @product.level=2
      when "1"
        @product.level=3
      end
      params[:url_sum].to_i.times do |index|
          image_item = ImageItem.new
          image_item.url = params["url"+(index+1).to_s]
          @product.image_items<<image_item
         image_item.save!
      end
       
    @product.save
    "ok".to_json
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

post :add_product_detail, :csrf_protection=>false do
    product=Product.find(params[:product_id])
    product_detail=ProductDetail.new
    product_detail.specification=params[:specification]
    product_detail.price=params[:price].to_f
    product_detail.storage=params[:storage].to_i
    product_detail.no_store=params[:storage].to_i
    product_detail.product=product
    product_detail.save
end
end



