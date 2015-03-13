SudayiBack::Admin.controllers :courier_stores do
  get :index do
    @title = "Courier_stores"
    @courier_stores = CourierStore.all
    render 'courier_stores/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'courier_store')
    @courier_store = CourierStore.new
    render 'courier_stores/new'
  end

  post :create do
    @courier_store = CourierStore.new(params[:courier_store])
    if @courier_store.save
      @title = pat(:create_title, :model => "courier_store #{@courier_store.id}")
      flash[:success] = pat(:create_success, :model => 'CourierStore')
      params[:save_and_continue] ? redirect(url(:courier_stores, :index)) : redirect(url(:courier_stores, :edit, :id => @courier_store.id))
    else
      @title = pat(:create_title, :model => 'courier_store')
      flash.now[:error] = pat(:create_error, :model => 'courier_store')
      render 'courier_stores/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "courier_store #{params[:id]}")
    @courier_store = CourierStore.find(params[:id])
    if @courier_store
      render 'courier_stores/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'courier_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "courier_store #{params[:id]}")
    @courier_store = CourierStore.find(params[:id])
    if @courier_store
      if @courier_store.update_attributes(params[:courier_store])
        flash[:success] = pat(:update_success, :model => 'Courier_store', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courier_stores, :index)) :
          redirect(url(:courier_stores, :edit, :id => @courier_store.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'courier_store')
        render 'courier_stores/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'courier_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courier_stores"
    courier_store = CourierStore.find(params[:id])
    if courier_store
      if courier_store.destroy
        flash[:success] = pat(:delete_success, :model => 'Courier_store', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'courier_store')
      end
      redirect url(:courier_stores, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'courier_store', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courier_stores"
    unless params[:courier_store_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'courier_store')
      redirect(url(:courier_stores, :index))
    end
    ids = params[:courier_store_ids].split(',').map(&:strip)
    courier_stores = CourierStore.find(ids)
    
    if courier_stores.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courier_stores', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courier_stores, :index)
  end
end
