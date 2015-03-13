SudayiBack::Admin.controllers :pay_types do
  get :index do
    @title = "Pay_types"
    @pay_types = PayType.all
    render 'pay_types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'pay_type')
    @pay_type = PayType.new
    render 'pay_types/new'
  end

  post :create do
    @pay_type = PayType.new(params[:pay_type])
    if @pay_type.save
      @title = pat(:create_title, :model => "pay_type #{@pay_type.id}")
      flash[:success] = pat(:create_success, :model => 'PayType')
      params[:save_and_continue] ? redirect(url(:pay_types, :index)) : redirect(url(:pay_types, :edit, :id => @pay_type.id))
    else
      @title = pat(:create_title, :model => 'pay_type')
      flash.now[:error] = pat(:create_error, :model => 'pay_type')
      render 'pay_types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "pay_type #{params[:id]}")
    @pay_type = PayType.find(params[:id])
    if @pay_type
      render 'pay_types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'pay_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "pay_type #{params[:id]}")
    @pay_type = PayType.find(params[:id])
    if @pay_type
      if @pay_type.update_attributes(params[:pay_type])
        flash[:success] = pat(:update_success, :model => 'Pay_type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:pay_types, :index)) :
          redirect(url(:pay_types, :edit, :id => @pay_type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'pay_type')
        render 'pay_types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'pay_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Pay_types"
    pay_type = PayType.find(params[:id])
    if pay_type
      if pay_type.destroy
        flash[:success] = pat(:delete_success, :model => 'Pay_type', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'pay_type')
      end
      redirect url(:pay_types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'pay_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Pay_types"
    unless params[:pay_type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'pay_type')
      redirect(url(:pay_types, :index))
    end
    ids = params[:pay_type_ids].split(',').map(&:strip)
    pay_types = PayType.find(ids)
    
    if pay_types.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Pay_types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:pay_types, :index)
  end
end
