SudayiBack::Admin.controllers :courier_addresses do
  get :index do
    @title = "Courier_addresses"
    @courier_addresses = CourierAddress.all
    render 'courier_addresses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'courier_address')
    @courier_address = CourierAddress.new
    render 'courier_addresses/new'
  end

  post :create do
    @courier_address = CourierAddress.new(params[:courier_address])
    if @courier_address.save
      @title = pat(:create_title, :model => "courier_address #{@courier_address.id}")
      flash[:success] = pat(:create_success, :model => 'CourierAddress')
      params[:save_and_continue] ? redirect(url(:courier_addresses, :index)) : redirect(url(:courier_addresses, :edit, :id => @courier_address.id))
    else
      @title = pat(:create_title, :model => 'courier_address')
      flash.now[:error] = pat(:create_error, :model => 'courier_address')
      render 'courier_addresses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "courier_address #{params[:id]}")
    @courier_address = CourierAddress.find(params[:id])
    if @courier_address
      render 'courier_addresses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'courier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "courier_address #{params[:id]}")
    @courier_address = CourierAddress.find(params[:id])
    if @courier_address
      if @courier_address.update_attributes(params[:courier_address])
        flash[:success] = pat(:update_success, :model => 'Courier_address', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courier_addresses, :index)) :
          redirect(url(:courier_addresses, :edit, :id => @courier_address.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'courier_address')
        render 'courier_addresses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'courier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courier_addresses"
    courier_address = CourierAddress.find(params[:id])
    if courier_address
      if courier_address.destroy
        flash[:success] = pat(:delete_success, :model => 'Courier_address', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'courier_address')
      end
      redirect url(:courier_addresses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'courier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courier_addresses"
    unless params[:courier_address_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'courier_address')
      redirect(url(:courier_addresses, :index))
    end
    ids = params[:courier_address_ids].split(',').map(&:strip)
    courier_addresses = CourierAddress.find(ids)
    
    if courier_addresses.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courier_addresses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courier_addresses, :index)
  end
end
