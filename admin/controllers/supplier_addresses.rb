SudayiBack::Admin.controllers :supplier_addresses do
  get :index do
    @title = "Supplier_addresses"
    @supplier_addresses = SupplierAddress.all
    render 'supplier_addresses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'supplier_address')
    @supplier_address = SupplierAddress.new
    render 'supplier_addresses/new'
  end

  post :create do
    @supplier_address = SupplierAddress.new(params[:supplier_address])
    if @supplier_address.save
      @title = pat(:create_title, :model => "supplier_address #{@supplier_address.id}")
      flash[:success] = pat(:create_success, :model => 'SupplierAddress')
      params[:save_and_continue] ? redirect(url(:supplier_addresses, :index)) : redirect(url(:supplier_addresses, :edit, :id => @supplier_address.id))
    else
      @title = pat(:create_title, :model => 'supplier_address')
      flash.now[:error] = pat(:create_error, :model => 'supplier_address')
      render 'supplier_addresses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "supplier_address #{params[:id]}")
    @supplier_address = SupplierAddress.find(params[:id])
    if @supplier_address
      render 'supplier_addresses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'supplier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "supplier_address #{params[:id]}")
    @supplier_address = SupplierAddress.find(params[:id])
    if @supplier_address
      if @supplier_address.update_attributes(params[:supplier_address])
        flash[:success] = pat(:update_success, :model => 'Supplier_address', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:supplier_addresses, :index)) :
          redirect(url(:supplier_addresses, :edit, :id => @supplier_address.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'supplier_address')
        render 'supplier_addresses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'supplier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Supplier_addresses"
    supplier_address = SupplierAddress.find(params[:id])
    if supplier_address
      if supplier_address.destroy
        flash[:success] = pat(:delete_success, :model => 'Supplier_address', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'supplier_address')
      end
      redirect url(:supplier_addresses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'supplier_address', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Supplier_addresses"
    unless params[:supplier_address_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'supplier_address')
      redirect(url(:supplier_addresses, :index))
    end
    ids = params[:supplier_address_ids].split(',').map(&:strip)
    supplier_addresses = SupplierAddress.find(ids)
    
    if supplier_addresses.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Supplier_addresses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:supplier_addresses, :index)
  end
end
