SudayiBack::Admin.controllers :courier_accounts do
  get :index do
    @title = "Courier_accounts"
    @courier_accounts = CourierAccount.all
    render 'courier_accounts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'courier_account')
    @courier_account = CourierAccount.new
    render 'courier_accounts/new'
  end

  post :create do
    @courier_account = CourierAccount.new(params[:courier_account])
    if @courier_account.save
      @title = pat(:create_title, :model => "courier_account #{@courier_account.id}")
      flash[:success] = pat(:create_success, :model => 'CourierAccount')
      params[:save_and_continue] ? redirect(url(:courier_accounts, :index)) : redirect(url(:courier_accounts, :edit, :id => @courier_account.id))
    else
      @title = pat(:create_title, :model => 'courier_account')
      flash.now[:error] = pat(:create_error, :model => 'courier_account')
      render 'courier_accounts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "courier_account #{params[:id]}")
    @courier_account = CourierAccount.find(params[:id])
    if @courier_account
      render 'courier_accounts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'courier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "courier_account #{params[:id]}")
    @courier_account = CourierAccount.find(params[:id])
    if @courier_account
      if @courier_account.update_attributes(params[:courier_account])
        flash[:success] = pat(:update_success, :model => 'Courier_account', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courier_accounts, :index)) :
          redirect(url(:courier_accounts, :edit, :id => @courier_account.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'courier_account')
        render 'courier_accounts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'courier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courier_accounts"
    courier_account = CourierAccount.find(params[:id])
    if courier_account
      if courier_account.destroy
        flash[:success] = pat(:delete_success, :model => 'Courier_account', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'courier_account')
      end
      redirect url(:courier_accounts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'courier_account', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courier_accounts"
    unless params[:courier_account_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'courier_account')
      redirect(url(:courier_accounts, :index))
    end
    ids = params[:courier_account_ids].split(',').map(&:strip)
    courier_accounts = CourierAccount.find(ids)
    
    if courier_accounts.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courier_accounts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courier_accounts, :index)
  end
end
