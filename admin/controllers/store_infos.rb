SudayiBack::Admin.controllers :store_infos do
  get :index do
    @title = "Store_infos"
    @store_infos = StoreInfo.all
    render 'store_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_info')
    @store_info = StoreInfo.new
    render 'store_infos/new'
  end

  post :create do
    @store_info = StoreInfo.new(params[:store_info])
    if @store_info.save
      @title = pat(:create_title, :model => "store_info #{@store_info.id}")
      flash[:success] = pat(:create_success, :model => 'StoreInfo')
      params[:save_and_continue] ? redirect(url(:store_infos, :index)) : redirect(url(:store_infos, :edit, :id => @store_info.id))
    else
      @title = pat(:create_title, :model => 'store_info')
      flash.now[:error] = pat(:create_error, :model => 'store_info')
      render 'store_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_info #{params[:id]}")
    @store_info = StoreInfo.find(params[:id])
    if @store_info
      render 'store_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_info #{params[:id]}")
    @store_info = StoreInfo.find(params[:id])
    if @store_info
      if @store_info.update_attributes(params[:store_info])
        flash[:success] = pat(:update_success, :model => 'Store_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_infos, :index)) :
          redirect(url(:store_infos, :edit, :id => @store_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_info')
        render 'store_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_infos"
    store_info = StoreInfo.find(params[:id])
    if store_info
      if store_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_info')
      end
      redirect url(:store_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_infos"
    unless params[:store_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_info')
      redirect(url(:store_infos, :index))
    end
    ids = params[:store_info_ids].split(',').map(&:strip)
    store_infos = StoreInfo.find(ids)
    
    if store_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_infos, :index)
  end
end
