SudayiBack::Admin.controllers :store_products do
  get :index do
    @title = "Store_products"
    @store_products = StoreProduct.all
    render 'store_products/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'store_product')
    @store_product = StoreProduct.new
    render 'store_products/new'
  end

  post :create do
    @store_product = StoreProduct.new(params[:store_product])
    if @store_product.save
      @title = pat(:create_title, :model => "store_product #{@store_product.id}")
      flash[:success] = pat(:create_success, :model => 'StoreProduct')
      params[:save_and_continue] ? redirect(url(:store_products, :index)) : redirect(url(:store_products, :edit, :id => @store_product.id))
    else
      @title = pat(:create_title, :model => 'store_product')
      flash.now[:error] = pat(:create_error, :model => 'store_product')
      render 'store_products/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "store_product #{params[:id]}")
    @store_product = StoreProduct.find(params[:id])
    if @store_product
      render 'store_products/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'store_product', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "store_product #{params[:id]}")
    @store_product = StoreProduct.find(params[:id])
    if @store_product
      if @store_product.update_attributes(params[:store_product])
        flash[:success] = pat(:update_success, :model => 'Store_product', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:store_products, :index)) :
          redirect(url(:store_products, :edit, :id => @store_product.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'store_product')
        render 'store_products/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'store_product', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Store_products"
    store_product = StoreProduct.find(params[:id])
    if store_product
      if store_product.destroy
        flash[:success] = pat(:delete_success, :model => 'Store_product', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'store_product')
      end
      redirect url(:store_products, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'store_product', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Store_products"
    unless params[:store_product_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'store_product')
      redirect(url(:store_products, :index))
    end
    ids = params[:store_product_ids].split(',').map(&:strip)
    store_products = StoreProduct.find(ids)
    
    if store_products.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Store_products', :ids => "#{ids.to_sentence}")
    end
    redirect url(:store_products, :index)
  end
end
