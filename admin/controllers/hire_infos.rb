SudayiBack::Admin.controllers :hire_infos do
  get :index do
    @title = "Hire_infos"
    @hire_infos = HireInfo.all
    render 'hire_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'hire_info')
    @hire_info = HireInfo.new
    render 'hire_infos/new'
  end

  post :create do
    @hire_info = HireInfo.new(params[:hire_info])
    if @hire_info.save
      @title = pat(:create_title, :model => "hire_info #{@hire_info.id}")
      flash[:success] = pat(:create_success, :model => 'HireInfo')
      params[:save_and_continue] ? redirect(url(:hire_infos, :index)) : redirect(url(:hire_infos, :edit, :id => @hire_info.id))
    else
      @title = pat(:create_title, :model => 'hire_info')
      flash.now[:error] = pat(:create_error, :model => 'hire_info')
      render 'hire_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "hire_info #{params[:id]}")
    @hire_info = HireInfo.find(params[:id])
    if @hire_info
      render 'hire_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'hire_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "hire_info #{params[:id]}")
    @hire_info = HireInfo.find(params[:id])
    if @hire_info
      if @hire_info.update_attributes(params[:hire_info])
        flash[:success] = pat(:update_success, :model => 'Hire_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:hire_infos, :index)) :
          redirect(url(:hire_infos, :edit, :id => @hire_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'hire_info')
        render 'hire_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'hire_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Hire_infos"
    hire_info = HireInfo.find(params[:id])
    if hire_info
      if hire_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Hire_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'hire_info')
      end
      redirect url(:hire_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'hire_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Hire_infos"
    unless params[:hire_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'hire_info')
      redirect(url(:hire_infos, :index))
    end
    ids = params[:hire_info_ids].split(',').map(&:strip)
    hire_infos = HireInfo.find(ids)
    
    if hire_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Hire_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:hire_infos, :index)
  end
end
