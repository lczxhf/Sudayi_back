SudayiBack::Admin.controllers :error_infos do
  get :index do
    @title = "Error_infos"
    @error_infos = ErrorInfo.all
    render 'error_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'error_info')
    @error_info = ErrorInfo.new
    render 'error_infos/new'
  end

  post :create do
    @error_info = ErrorInfo.new(params[:error_info])
    if @error_info.save
      @title = pat(:create_title, :model => "error_info #{@error_info.id}")
      flash[:success] = pat(:create_success, :model => 'ErrorInfo')
      params[:save_and_continue] ? redirect(url(:error_infos, :index)) : redirect(url(:error_infos, :edit, :id => @error_info.id))
    else
      @title = pat(:create_title, :model => 'error_info')
      flash.now[:error] = pat(:create_error, :model => 'error_info')
      render 'error_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "error_info #{params[:id]}")
    @error_info = ErrorInfo.find(params[:id])
    if @error_info
      render 'error_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'error_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "error_info #{params[:id]}")
    @error_info = ErrorInfo.find(params[:id])
    if @error_info
      if @error_info.update_attributes(params[:error_info])
        flash[:success] = pat(:update_success, :model => 'Error_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:error_infos, :index)) :
          redirect(url(:error_infos, :edit, :id => @error_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'error_info')
        render 'error_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'error_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Error_infos"
    error_info = ErrorInfo.find(params[:id])
    if error_info
      if error_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Error_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'error_info')
      end
      redirect url(:error_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'error_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Error_infos"
    unless params[:error_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'error_info')
      redirect(url(:error_infos, :index))
    end
    ids = params[:error_info_ids].split(',').map(&:strip)
    error_infos = ErrorInfo.find(ids)
    
    if error_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Error_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:error_infos, :index)
  end
end
