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
  logger.info params
   if params[:params_number].to_i==params.size-1
    if !Store.where(name:params[:warehouse_name]).first        #判断仓库名是否已经存在
     account=SupplierAccount.find(params[:user_id])
     @store = Store.new
     store_info=StoreInfo.new
     store_type=StoreType.where(name:params[:type])
     @store.name = params[:warehouse_name]
     @store.supplier_account = account
     store_info.store=@store
     store_info.store_url = params[:store_url]
     logger.info params[:store_url].class
     store_info.open_time_begin_day = params[:first_time]
     store_info.open_time_end_day = params[:last_time]     
     store_info.address_reminder=params[:reminder]
     store_info.manager_name=params[:m_name]
     store_info.manager_phone=params[:m_phone]
     store_info.store_type=StoreType.where(name:params[:type]).first
     store_address=StoreAddress.new
     store_address.node=Node.find(params[:node_id])
     store_address.detail=Detail.create(name:params[:details])
     @store.store_address = store_address
     state = State.where(code:'01').first
     @store.state = state
     
     case params[:type]
     when "deposit"
      store_info.end_date=Date.parse("2100-1-1")

     when "firm_info"
      
      store_info.end_date= Time.mktime(params[:year].to_i,params[:month].to_i,params[:day].to_i)
      firm_info=FirmInfo.new
      firm_info.firm_name=params[:firm_name]
      firm_info.legal_person=params[:legal_person]
      firm_info.business_license_number=params[:bl_number]
      firm_info.legal_person_card=params[:legal_card]
      @store.set_store_info(firm_info,account._id,state._id,params[:url],params[:url2],params[:url3],params[:url4])
     when "hire_info"
      store_info.end_date= Time.mktime(params[:year].to_i,params[:month].to_i,params[:day].to_i)
      hire_info=HireInfo.new
      hire_info.lessee_name=params[:lessee_name]
      hire_info.lessee_card=params[:lessee_card]
      @store.set_store_info(hire_info,account._id,state._id,params[:url],params[:url2],params[:url3],params[:url4])
     when "myself_info"
      store_info.end_date=(Time.now+params[:month].to_i.month).strftime("%Y%m%d")
      myself_info=MyselfInfo.new
      myself_info.porperty_own_name=params[:p_own_name]
      myself_info.porperty_own_card=params[:p_own_card]
      myself_info.porperty_card=params[:p_card]
      myself_info.porperty_number=params[:p_number]
      @store.set_store_info(myself_info,account._id,state._id,params[:url],params[:url2],params[:url3],params[:url4])
     end
     if @store.save
        store_info.save
        store_address.save
        @store._id.to_json
     else
        "添加失败"
     end
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

get :set_store_status do
  store=Store.find(params[:store_id])
  if store
    store.is_open=!store.is_open
    store.save
  else
    "仓库不存在".to_json
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
