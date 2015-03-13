SudayiBack::Admin.controllers :courier_employees do
  get :index do
    @title = "Courier_employees"
    @courier_employees = CourierEmployee.all
    render 'courier_employees/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'courier_employee')
    @courier_employee = CourierEmployee.new
    render 'courier_employees/new'
  end

  post :create do
    @courier_employee = CourierEmployee.new(params[:courier_employee])
    if @courier_employee.save
      @title = pat(:create_title, :model => "courier_employee #{@courier_employee.id}")
      flash[:success] = pat(:create_success, :model => 'CourierEmployee')
      params[:save_and_continue] ? redirect(url(:courier_employees, :index)) : redirect(url(:courier_employees, :edit, :id => @courier_employee.id))
    else
      @title = pat(:create_title, :model => 'courier_employee')
      flash.now[:error] = pat(:create_error, :model => 'courier_employee')
      render 'courier_employees/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "courier_employee #{params[:id]}")
    @courier_employee = CourierEmployee.find(params[:id])
    if @courier_employee
      render 'courier_employees/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'courier_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "courier_employee #{params[:id]}")
    @courier_employee = CourierEmployee.find(params[:id])
    if @courier_employee
      if @courier_employee.update_attributes(params[:courier_employee])
        flash[:success] = pat(:update_success, :model => 'Courier_employee', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courier_employees, :index)) :
          redirect(url(:courier_employees, :edit, :id => @courier_employee.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'courier_employee')
        render 'courier_employees/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'courier_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courier_employees"
    courier_employee = CourierEmployee.find(params[:id])
    if courier_employee
      if courier_employee.destroy
        flash[:success] = pat(:delete_success, :model => 'Courier_employee', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'courier_employee')
      end
      redirect url(:courier_employees, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'courier_employee', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courier_employees"
    unless params[:courier_employee_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'courier_employee')
      redirect(url(:courier_employees, :index))
    end
    ids = params[:courier_employee_ids].split(',').map(&:strip)
    courier_employees = CourierEmployee.find(ids)
    
    if courier_employees.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courier_employees', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courier_employees, :index)
  end
end
