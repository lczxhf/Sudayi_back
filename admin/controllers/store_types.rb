SudayiBack::Admin.controllers :store_types do
  get :index do
    @title = "Store_types"
    @store_types = StoreType.all
    render 'store_types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_type')
    @store_type = StoreType.new
    render 'store_types/new'
  end

  post :create do
    @store_type = StoreType.new(params[:store_type])
    if @store_type.save
      @title = pat(:create_title, :model => "store_type #{@store_type.id}")
      flash[:success] = pat(:create_success, :model => 'StoreType')
      params[:save_and_continue] ? redirect(url(:store_types, :index)) : redirect(url(:store_types, :edit, :id => @store_type.id))
    else
      @title = pat(:create_title, :model => 'store_type')
      flash.now[:error] = pat(:create_error, :model => 'store_type')
      render 'store_types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_type #{params[:id]}")
    @store_type = StoreType.find(params[:id])
    if @store_type
      render 'store_types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_type #{params[:id]}")
    @store_type = StoreType.find(params[:id])
    if @store_type
      if @store_type.update_attributes(params[:store_type])
        flash[:success] = pat(:update_success, :model => 'Store_type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_types, :index)) :
          redirect(url(:store_types, :edit, :id => @store_type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_type')
        render 'store_types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_types"
    store_type = StoreType.find(params[:id])
    if store_type
      if store_type.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_type', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_type')
      end
      redirect url(:store_types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_types"
    unless params[:store_type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_type')
      redirect(url(:store_types, :index))
    end
    ids = params[:store_type_ids].split(',').map(&:strip)
    store_types = StoreType.find(ids)
    
    if store_types.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_types, :index)
  end
end
