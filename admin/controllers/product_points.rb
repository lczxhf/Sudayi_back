SudayiBack::Admin.controllers :product_points do
  get :index do
    @title = "Product_points"
    @product_points = ProductPoint.all
    render 'product_points/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'product_point')
    @product_point = ProductPoint.new
    render 'product_points/new'
  end

  post :create do
    @product_point = ProductPoint.new(params[:product_point])
    if @product_point.save
      @title = pat(:create_title, :model => "product_point #{@product_point.id}")
      flash[:success] = pat(:create_success, :model => 'ProductPoint')
      params[:save_and_continue] ? redirect(url(:product_points, :index)) : redirect(url(:product_points, :edit, :id => @product_point.id))
    else
      @title = pat(:create_title, :model => 'product_point')
      flash.now[:error] = pat(:create_error, :model => 'product_point')
      render 'product_points/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "product_point #{params[:id]}")
    @product_point = ProductPoint.find(params[:id])
    if @product_point
      render 'product_points/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'product_point', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "product_point #{params[:id]}")
    @product_point = ProductPoint.find(params[:id])
    if @product_point
      if @product_point.update_attributes(params[:product_point])
        flash[:success] = pat(:update_success, :model => 'Product_point', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:product_points, :index)) :
          redirect(url(:product_points, :edit, :id => @product_point.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'product_point')
        render 'product_points/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'product_point', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Product_points"
    product_point = ProductPoint.find(params[:id])
    if product_point
      if product_point.destroy
        flash[:success] = pat(:delete_success, :model => 'Product_point', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'product_point')
      end
      redirect url(:product_points, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'product_point', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Product_points"
    unless params[:product_point_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'product_point')
      redirect(url(:product_points, :index))
    end
    ids = params[:product_point_ids].split(',').map(&:strip)
    product_points = ProductPoint.find(ids)
    
    if product_points.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Product_points', :ids => "#{ids.to_sentence}")
    end
    redirect url(:product_points, :index)
  end
end
