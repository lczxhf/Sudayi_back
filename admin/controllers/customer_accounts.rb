SudayiBack::Admin.controllers :customer_accounts do
  get :index do
    @title = "Customer_accounts"
    @customer_accounts = CustomerAccount.all
    render 'customer_accounts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'customer_account')
    @customer_account = CustomerAccount.new
    render 'customer_accounts/new'
  end

  post :create do
    @customer_account = CustomerAccount.new(params[:customer_account])
    if @customer_account.save
      @title = pat(:create_title, :model => "customer_account #{@customer_account.id}")
      flash[:success] = pat(:create_success, :model => 'CustomerAccount')
      params[:save_and_continue] ? redirect(url(:customer_accounts, :index)) : redirect(url(:customer_accounts, :edit, :id => @customer_account.id))
    else
      @title = pat(:create_title, :model => 'customer_account')
      flash.now[:error] = pat(:create_error, :model => 'customer_account')
      render 'customer_accounts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "customer_account #{params[:id]}")
    @customer_account = CustomerAccount.find(params[:id])
    if @customer_account
      render 'customer_accounts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'customer_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "customer_account #{params[:id]}")
    @customer_account = CustomerAccount.find(params[:id])
    if @customer_account
      if @customer_account.update_attributes(params[:customer_account])
        flash[:success] = pat(:update_success, :model => 'Customer_account', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:customer_accounts, :index)) :
          redirect(url(:customer_accounts, :edit, :id => @customer_account.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'customer_account')
        render 'customer_accounts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'customer_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Customer_accounts"
    customer_account = CustomerAccount.find(params[:id])
    if customer_account
      if customer_account.destroy
        flash[:success] = pat(:delete_success, :model => 'Customer_account', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'customer_account')
      end
      redirect url(:customer_accounts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'customer_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Customer_accounts"
    unless params[:customer_account_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'customer_account')
      redirect(url(:customer_accounts, :index))
    end
    ids = params[:customer_account_ids].split(',').map(&:strip)
    customer_accounts = CustomerAccount.find(ids)
    
    if customer_accounts.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Customer_accounts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:customer_accounts, :index)
  end
end
