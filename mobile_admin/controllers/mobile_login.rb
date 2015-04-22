SudayiBack::MobileAdmin.controllers :mobile_login do
  use Rack::Cors do
  allow do
    # put real origins here
    origins '*', 'null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
 end 

 before do
    if params[:is_pc]
       @is_pc=true
    end
 end
 
 #登陆
 post :get_account,:csrf_protection=>false do
   if params[:account_type]=='supplier'                                                #判断登陆的是供应商还是代理商
      logger.info params
      @account = SupplierAccount.authenticate_mobile(params[:mobile], params[:password])    #调用model类的静态方法
   else
      @account = CourierAccount.authenticate_mobile(params[:mobile], params[:password])
   end
     if  @account
         @account.to_json
     else
       if @is_pc
         
       else
        "密码或手机错误".to_json
       end
     end
 end

#验证手机是否已存在
 get :judge_same_mobile do
    @account = SupplierAccount.where(:mobile => params[:mobile]).first
    if @account
        'false,该手机号码已被注册'.to_json
    else
        if params[:mobile].length != 11             #判断输入的手机是否是11位
          "false,手机号码有误".to_json
        else
           ("true," + params[:mobile]).to_json
        end
    end
 end

#创建供应商账户
 get :create_account do
   if params[:area_id]                #判断是否填写了地址!
     @account = SupplierAccount.new(:password_confirmation => params[:apwd], :mobile => params[:tel], :password => params[:pwd])
     area = Area.find(params[:area_id])
     city = area.city
     province = city.province
     country = province.country
     @account.create_supplier_address(area_id:area._id,city_id:city._id,province_id:province._id,country_id:country._id)
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
   if params[:user_id] and params[:user_id] != 'null'
      if params[:account_type]=='supplier'
          account = SupplierAccount.find(params[:user_id])
      else
          account = CourierAccount.find(params[:user_id])
      end
        
        result = '未认证'
        if account.credit_info                          #判断这个用户是否认证过个人认证
            result = account.credit_info.name
        end
        if account.firm_info                             #判断这个用户是否认证过企业认证
            result = account.firm_info.legal_person
        end 
        render:html,result.to_json  
   end
 end

#创建供应商/代理商账户的个人认证
post :update_account_info, :csrf_protection =>false do
  if params[:user_id] && params[:url1] && params[:url2] && params[:url3] && params[:name] && params[:card_number] && params[:address]
      if !CreditInfo.where(card_id:params[:card_number]).first         #判断身份证号是否已被认证过
       @state = State.where(:code => '01').first
       url1 = params[:url1]
       url2 = params[:url2]
       url3 = params[:url3]
       @credit_info = CreditInfo.new(:name => params[:name], :card_id => params[:card_number] ,:url => url1,:url2 => url2,:url3=>url3)
       @credit_info.state = @state
       detail = Detail.create(name:params[:address])
       if params[:account_type]=='supplier'
             @account = SupplierAccount.where(:_id=>params[:user_id]).first
             @credit_info.supplier_account = @account
             @account.supplier_address.detail_id = detail._id
             @account.courier_address.save
       else
              @account = CourierAccount.where(:_id=>params[:user_id]).first
              @credit_info.courier_account = @account
              @account.courier_address.detail_id = detail._id
              @account.courier_address.save
       end
       
       @credit_info.save
       @credit_info.to_json
      else
          "该身份证号已被注册".to_json
      end
    
  else
     "请填写完整的信息".to_json
  end
end

#创建供应商/代理商账户的公司认证
post :update_firm_info,:csrf_protection=>false do
  if params[:name] && params[:user_id] && params[:legal_person] && params[:number] && params[:code] && params[:url1] && params[:url2] && params[:url3] && params[:address]
        #判断公司命、营业执照、机构代码是否已被认证过
         if FirmInfo.where(firm_name:params[:name]).first || FirmInfo.where(business_license_number:params[:number]).first || FirmInfo.where(org_code:params[:code]).first 
            "该公司信息已被注册".to_json
         else
            @state = State.where(:code => '01').first
    #        firm_type=FirmType.where(name:params[:firm_type]).first
            url1 = params[:url1]
            url2 = params[:url2]
            url3=params[:url3]
            @firm_info = FirmInfo.new(firm_name:params[:name],legal_person:params[:legal_person],business_license_number:params[:number],org_code:params[:code],url:url1,url2:url2,url3:url3) 
            @firm_info.state = @state
           
            if params[:account_type] == 'supplier'
              @account = SupplierAccount.find(params[:user_id])
              @firm_info.supplier_account = @account
            else
              @account = CourierAccount.find(params[:user_id])
              @firm_info.courier_account = @account
            end
            
            detail = Detail.create(name:params[:address])
            @firm_info.firm_address = FirmAddress.create
            @firm_info.firm_address.detail = detail
            @firm_info.firm_address.save
  #       @firm_info.firm_type=firm_type
            @firm_info.save
            @firm_info.to_json
        end
       
  else
      "请完整地填写信息".to_json
  end

end

end


