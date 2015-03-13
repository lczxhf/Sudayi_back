SudayiBack::Admin.controllers :courier_orders do
  get :index do
    @title = "Courier_orders"
    @courier_orders = CourierOrder.all
    render 'courier_orders/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'courier_order')
    @courier_order = CourierOrder.new
    render 'courier_orders/new'
  end

  post :create do
    @courier_order = CourierOrder.new(params[:courier_order])
    if @courier_order.save
      @title = pat(:create_title, :model => "courier_order #{@courier_order.id}")
      flash[:success] = pat(:create_success, :model => 'CourierOrder')
      params[:save_and_continue] ? redirect(url(:courier_orders, :index)) : redirect(url(:courier_orders, :edit, :id => @courier_order.id))
    else
      @title = pat(:create_title, :model => 'courier_order')
      flash.now[:error] = pat(:create_error, :model => 'courier_order')
      render 'courier_orders/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "courier_order #{params[:id]}")
    @courier_order = CourierOrder.find(params[:id])
    if @courier_order
      render 'courier_orders/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'courier_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "courier_order #{params[:id]}")
    @courier_order = CourierOrder.find(params[:id])
    if @courier_order
      if @courier_order.update_attributes(params[:courier_order])
        flash[:success] = pat(:update_success, :model => 'Courier_order', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courier_orders, :index)) :
          redirect(url(:courier_orders, :edit, :id => @courier_order.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'courier_order')
        render 'courier_orders/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'courier_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courier_orders"
    courier_order = CourierOrder.find(params[:id])
    if courier_order
      if courier_order.destroy
        flash[:success] = pat(:delete_success, :model => 'Courier_order', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'courier_order')
      end
      redirect url(:courier_orders, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'courier_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courier_orders"
    unless params[:courier_order_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'courier_order')
      redirect(url(:courier_orders, :index))
    end
    ids = params[:courier_order_ids].split(',').map(&:strip)
    courier_orders = CourierOrder.find(ids)
    
    if courier_orders.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courier_orders', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courier_orders, :index)
  end
end
