SudayiBack::MobileAdmin.controllers :mobile_login do
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
 end 
  
#验证手机是否已存在
 get :judge_same_mobile do
    @account =SupplierAccount.where(:mobile => params[:mobile]).first
    if @account
        'false,该手机号码已被注册'.to_json
    else
        if params[:mobile].length!=11
          "false,手机号码有误".to_json
        else
           ("true,"+params[:mobile]).to_json
        end
    end
 end

#创建供应商账户
 get :create_account do
   if params[:area_id]
     @account=SupplierAccount.new(:password_confirmation => params[:apwd], :mobile => params[:tel], :password => params[:pwd])
     area=Area.find(params[:area_id])
     city=area.city
     province=city.province
     country=province.country
     @account.create_address(area_id:area._id,city_id:city._id,province_id:province._id,country_id:country._id)
     if @account.save
       @account.to_json
     else
      
       @account.errors.to_json
     end  
  else
     "请填写地址".to_json
  end
 end

#判断是否已经个人验证或企业验证
 get :is_authentication do
   if params[:user_id] and params[:user_id]!='null'
        account=SupplierAccount.find(params[:user_id])
        result='未认证'
        if account.credit_info
            result=account.credit_info.name
        end
        if account.firm_info
            result=account.firm_info.legal_person
        end 
        render:html,result.to_json  
   end
 end

#创建供应商账户的个人认证
post :update_account_info, :csrf_protection =>false do
  if params[:user_id] and params[:url1] and params[:url2] and params[:url3] and params[:name] and params[:card_number] and params[:address]
    @account =SupplierAccount.where(:_id=>params[:user_id]).first
    if @account
      if !CreditInfo.where(card_id:params[:card_number]).first 
       @state=State.where(:code => '01').first
       url1 = params[:url1]
       url2 = params[:url2]
       url3 = params[:url3]
       @credit_info = CreditInfo.new(:name => params[:name], :card_id => params[:card_number] ,:url => url1,:url2 => url2,:url3=>url3)
       @credit_info.state=@state
       @credit_info.supplier_account=@account
       @credit_info.save
       detail=Detail.create(name:params[:address])
       @account.address.detail_id=detail._id
       @account.address.save
       @credit_info.to_json
      else
          "该身份证号已被注册".to_json
      end
    else
         "账户不存在".to_json
    end
  else
     "请填写完整的信息".to_json
  end
end

end


