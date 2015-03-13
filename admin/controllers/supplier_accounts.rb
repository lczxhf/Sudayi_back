SudayiBack::Admin.controllers :supplier_accounts do
  get :index do
    @title = "Supplier_accounts"
    @supplier_accounts = SupplierAccount.all
    render 'supplier_accounts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'supplier_account')
    @supplier_account = SupplierAccount.new
    render 'supplier_accounts/new'
  end

  post :create do
    @supplier_account = SupplierAccount.new(params[:supplier_account])
    if @supplier_account.save
      @title = pat(:create_title, :model => "supplier_account #{@supplier_account.id}")
      flash[:success] = pat(:create_success, :model => 'SupplierAccount')
      params[:save_and_continue] ? redirect(url(:supplier_accounts, :index)) : redirect(url(:supplier_accounts, :edit, :id => @supplier_account.id))
    else
      @title = pat(:create_title, :model => 'supplier_account')
      flash.now[:error] = pat(:create_error, :model => 'supplier_account')
      render 'supplier_accounts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "supplier_account #{params[:id]}")
    @supplier_account = SupplierAccount.find(params[:id])
    if @supplier_account
      render 'supplier_accounts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'supplier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "supplier_account #{params[:id]}")
    @supplier_account = SupplierAccount.find(params[:id])
    if @supplier_account
      if @supplier_account.update_attributes(params[:supplier_account])
        flash[:success] = pat(:update_success, :model => 'Supplier_account', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:supplier_accounts, :index)) :
          redirect(url(:supplier_accounts, :edit, :id => @supplier_account.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'supplier_account')
        render 'supplier_accounts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'supplier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Supplier_accounts"
    supplier_account = SupplierAccount.find(params[:id])
    if supplier_account
      if supplier_account.destroy
        flash[:success] = pat(:delete_success, :model => 'Supplier_account', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'supplier_account')
      end
      redirect url(:supplier_accounts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'supplier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Supplier_accounts"
    unless params[:supplier_account_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'supplier_account')
      redirect(url(:supplier_accounts, :index))
    end
    ids = params[:supplier_account_ids].split(',').map(&:strip)
    supplier_accounts = SupplierAccount.find(ids)
    
    if supplier_accounts.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Supplier_accounts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:supplier_accounts, :index)
  end
end
