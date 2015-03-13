SudayiBack::Admin.controllers :order_settings do
  get :index do
    @title = "Order_settings"
    @order_settings = OrderSetting.all
    render 'order_settings/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'order_setting')
    @order_setting = OrderSetting.new
    render 'order_settings/new'
  end

  post :create do
    @order_setting = OrderSetting.new(params[:order_setting])
    if @order_setting.save
      @title = pat(:create_title, :model => "order_setting #{@order_setting.id}")
      flash[:success] = pat(:create_success, :model => 'OrderSetting')
      params[:save_and_continue] ? redirect(url(:order_settings, :index)) : redirect(url(:order_settings, :edit, :id => @order_setting.id))
    else
      @title = pat(:create_title, :model => 'order_setting')
      flash.now[:error] = pat(:create_error, :model => 'order_setting')
      render 'order_settings/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "order_setting #{params[:id]}")
    @order_setting = OrderSetting.find(params[:id])
    if @order_setting
      render 'order_settings/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'order_setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "order_setting #{params[:id]}")
    @order_setting = OrderSetting.find(params[:id])
    if @order_setting
      if @order_setting.update_attributes(params[:order_setting])
        flash[:success] = pat(:update_success, :model => 'Order_setting', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:order_settings, :index)) :
          redirect(url(:order_settings, :edit, :id => @order_setting.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'order_setting')
        render 'order_settings/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'order_setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Order_settings"
    order_setting = OrderSetting.find(params[:id])
    if order_setting
      if order_setting.destroy
        flash[:success] = pat(:delete_success, :model => 'Order_setting', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'order_setting')
      end
      redirect url(:order_settings, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'order_setting', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Order_settings"
    unless params[:order_setting_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'order_setting')
      redirect(url(:order_settings, :index))
    end
    ids = params[:order_setting_ids].split(',').map(&:strip)
    order_settings = OrderSetting.find(ids)
    
    if order_settings.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Order_settings', :ids => "#{ids.to_sentence}")
    end
    redirect url(:order_settings, :index)
  end
end
