SudayiBack::Admin.controllers :firm_addresses do
  get :index do
    @title = "Firm_addresses"
    @firm_addresses = FirmAddress.all
    render 'firm_addresses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'firm_address')
    @firm_address = FirmAddress.new
    render 'firm_addresses/new'
  end

  post :create do
    @firm_address = FirmAddress.new(params[:firm_address])
    if @firm_address.save
      @title = pat(:create_title, :model => "firm_address #{@firm_address.id}")
      flash[:success] = pat(:create_success, :model => 'FirmAddress')
      params[:save_and_continue] ? redirect(url(:firm_addresses, :index)) : redirect(url(:firm_addresses, :edit, :id => @firm_address.id))
    else
      @title = pat(:create_title, :model => 'firm_address')
      flash.now[:error] = pat(:create_error, :model => 'firm_address')
      render 'firm_addresses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "firm_address #{params[:id]}")
    @firm_address = FirmAddress.find(params[:id])
    if @firm_address
      render 'firm_addresses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'firm_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "firm_address #{params[:id]}")
    @firm_address = FirmAddress.find(params[:id])
    if @firm_address
      if @firm_address.update_attributes(params[:firm_address])
        flash[:success] = pat(:update_success, :model => 'Firm_address', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:firm_addresses, :index)) :
          redirect(url(:firm_addresses, :edit, :id => @firm_address.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'firm_address')
        render 'firm_addresses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'firm_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Firm_addresses"
    firm_address = FirmAddress.find(params[:id])
    if firm_address
      if firm_address.destroy
        flash[:success] = pat(:delete_success, :model => 'Firm_address', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'firm_address')
      end
      redirect url(:firm_addresses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'firm_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Firm_addresses"
    unless params[:firm_address_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'firm_address')
      redirect(url(:firm_addresses, :index))
    end
    ids = params[:firm_address_ids].split(',').map(&:strip)
    firm_addresses = FirmAddress.find(ids)
    
    if firm_addresses.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Firm_addresses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:firm_addresses, :index)
  end
end
