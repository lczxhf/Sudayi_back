SudayiBack::Admin.controllers :product_details do
  get :index do
    @title = "Product_details"
    @product_details = ProductDetail.all
    render 'product_details/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product_detail')
    @product_detail = ProductDetail.new
    render 'product_details/new'
  end

  post :create do
    @product_detail = ProductDetail.new(params[:product_detail])
    if @product_detail.save
      @title = pat(:create_title, :model => "product_detail #{@product_detail.id}")
      flash[:success] = pat(:create_success, :model => 'ProductDetail')
      params[:save_and_continue] ? redirect(url(:product_details, :index)) : redirect(url(:product_details, :edit, :id => @product_detail.id))
    else
      @title = pat(:create_title, :model => 'product_detail')
      flash.now[:error] = pat(:create_error, :model => 'product_detail')
      render 'product_details/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product_detail #{params[:id]}")
    @product_detail = ProductDetail.find(params[:id])
    if @product_detail
      render 'product_details/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product_detail', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product_detail #{params[:id]}")
    @product_detail = ProductDetail.find(params[:id])
    if @product_detail
      if @product_detail.update_attributes(params[:product_detail])
        flash[:success] = pat(:update_success, :model => 'Product_detail', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:product_details, :index)) :
          redirect(url(:product_details, :edit, :id => @product_detail.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product_detail')
        render 'product_details/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product_detail', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Product_details"
    product_detail = ProductDetail.find(params[:id])
    if product_detail
      if product_detail.destroy
        flash[:success] = pat(:delete_success, :model => 'Product_detail', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product_detail')
      end
      redirect url(:product_details, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product_detail', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Product_details"
    unless params[:product_detail_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product_detail')
      redirect(url(:product_details, :index))
    end
    ids = params[:product_detail_ids].split(',').map(&:strip)
    product_details = ProductDetail.find(ids)
    
    if product_details.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Product_details', :ids => "#{ids.to_sentence}")
    end
    redirect url(:product_details, :index)
  end
end
