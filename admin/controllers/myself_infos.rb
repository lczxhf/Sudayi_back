SudayiBack::Admin.controllers :myself_infos do
  get :index do
    @title = "Myself_infos"
    @myself_infos = MyselfInfo.all
    render 'myself_infos/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'myself_info')
    @myself_info = MyselfInfo.new
    render 'myself_infos/new'
  end

  post :create do
    @myself_info = MyselfInfo.new(params[:myself_info])
    if @myself_info.save
      @title = pat(:create_title, :model => "myself_info #{@myself_info.id}")
      flash[:success] = pat(:create_success, :model => 'MyselfInfo')
      params[:save_and_continue] ? redirect(url(:myself_infos, :index)) : redirect(url(:myself_infos, :edit, :id => @myself_info.id))
    else
      @title = pat(:create_title, :model => 'myself_info')
      flash.now[:error] = pat(:create_error, :model => 'myself_info')
      render 'myself_infos/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "myself_info #{params[:id]}")
    @myself_info = MyselfInfo.find(params[:id])
    if @myself_info
      render 'myself_infos/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'myself_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "myself_info #{params[:id]}")
    @myself_info = MyselfInfo.find(params[:id])
    if @myself_info
      if @myself_info.update_attributes(params[:myself_info])
        flash[:success] = pat(:update_success, :model => 'Myself_info', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:myself_infos, :index)) :
          redirect(url(:myself_infos, :edit, :id => @myself_info.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'myself_info')
        render 'myself_infos/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'myself_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Myself_infos"
    myself_info = MyselfInfo.find(params[:id])
    if myself_info
      if myself_info.destroy
        flash[:success] = pat(:delete_success, :model => 'Myself_info', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'myself_info')
      end
      redirect url(:myself_infos, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'myself_info', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Myself_infos"
    unless params[:myself_info_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'myself_info')
      redirect(url(:myself_infos, :index))
    end
    ids = params[:myself_info_ids].split(',').map(&:strip)
    myself_infos = MyselfInfo.find(ids)
    
    if myself_infos.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Myself_infos', :ids => "#{ids.to_sentence}")
    end
    redirect url(:myself_infos, :index)
  end
end
