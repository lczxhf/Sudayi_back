SudayiBack::Admin.controllers :back_orders do
  get :index do
    @title = "Back_orders"
    @back_orders = BackOrder.all
    render 'back_orders/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'back_order')
    @back_order = BackOrder.new
    render 'back_orders/new'
  end

  post :create do
    @back_order = BackOrder.new(params[:back_order])
    if @back_order.save
      @title = pat(:create_title, :model => "back_order #{@back_order.id}")
      flash[:success] = pat(:create_success, :model => 'BackOrder')
      params[:save_and_continue] ? redirect(url(:back_orders, :index)) : redirect(url(:back_orders, :edit, :id => @back_order.id))
    else
      @title = pat(:create_title, :model => 'back_order')
      flash.now[:error] = pat(:create_error, :model => 'back_order')
      render 'back_orders/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "back_order #{params[:id]}")
    @back_order = BackOrder.find(params[:id])
    if @back_order
      render 'back_orders/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'back_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "back_order #{params[:id]}")
    @back_order = BackOrder.find(params[:id])
    if @back_order
      if @back_order.update_attributes(params[:back_order])
        flash[:success] = pat(:update_success, :model => 'Back_order', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:back_orders, :index)) :
          redirect(url(:back_orders, :edit, :id => @back_order.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'back_order')
        render 'back_orders/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'back_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Back_orders"
    back_order = BackOrder.find(params[:id])
    if back_order
      if back_order.destroy
        flash[:success] = pat(:delete_success, :model => 'Back_order', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'back_order')
      end
      redirect url(:back_orders, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'back_order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Back_orders"
    unless params[:back_order_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'back_order')
      redirect(url(:back_orders, :index))
    end
    ids = params[:back_order_ids].split(',').map(&:strip)
    back_orders = BackOrder.find(ids)
    
    if back_orders.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Back_orders', :ids => "#{ids.to_sentence}")
    end
    redirect url(:back_orders, :index)
  end
end
