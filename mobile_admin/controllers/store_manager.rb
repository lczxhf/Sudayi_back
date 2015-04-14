SudayiBack::MobileAdmin.controllers :store_manager do
 require 'date'
 require 'json'
use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
 end 


post :new_store,:csrf_protection => false do
   if params[:url] && params[:warehouse_name] && params[:end_date] && params[:user_id] && params[:node_id] && params[:warehouse_addres]
    if !Store.where(name:params[:warehouse_name]).first        #判断仓库名是否已经存在
     @store = Store.new
     @store.credit_url = params[:url]
     @store.name = params[:warehouse_name]
   # @store.open_time_begin_day = params[:first_time]
   # @store.open_time_end_day = params[:last_time]
   # @store.open_time_in_one_week = params[:day]
     @store.end_date=Date.parse(params[:end_date])
     @store.account_id = params[:user_id]
     @store.node_id = params[:node_id] 
     state = State.where(code:'01').first
     @store.state = state
     @store_address = StoreAddress.new
     @store_address.details = params[:warehouse_address]
     @store_address.save
     @store.store_address = @store_address
     @store.save
     @store._id.to_json
    else
  '仓库已存在'.to_json
    end
   else
    '请将信息填写完整'.to_json
   end
end
 
 #获取某供应商的所有仓库
get :get_all_store do
  stores=Store.where(account_id:params[:user_id])
  if !stores.empty?
  stores.to_json(:include=>{:store_address=>{:only=>:details},:node=>{:include=>{:city=>{:only=>:name},:area=>{:only=>:name}},:only=>[:city]}},:only=>[:_id,:name])
  else
  "此账号不存在仓库".to_json
  end
end 

post :insert_product_to_store,:csrf_protection => false do
  store = Store.find(params[:store_id])
  if store
    (params.size-1)/2.times do |index|
      if params['amount'+index.to_s]
        product_detail = ProductDetail.find(params['c_id'+index.to_s])
        amount = params['amount'+index.to_s].to_i
           if product_detail.no_store<=amount
               product_store = ProductStore.where(product_detail_id:params['c_id'+index.to_s],store_id:params[:store_id]).first
               if !product_store
                   product_store = ProductStore.new
                   product_store.store = store
                   product_store.product_detail = product_detail
                   product_store.amount = amount
               else
                   product_store.amount+=amount
               end
               product_store.save
               product_detail.no_store-=amount
               product_detail.save
          else
              "请填写真确的数量".to_json
          end
      end
    end
      render :html,"true"
  else
      "仓库不存在".to_json
  end
  
end

end
