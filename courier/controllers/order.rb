SudayiBack::Courier.controllers :order do

get :courier_vali do
    courier_order=CourierOrder.find(params[:order_id])
    courier_order.order_time.courier_time=Time.now
    number=courier_order.order_time.store_time[0]
    if number==(courier_order.order_time.store_time.size-1)
        order=courier_order.orders.asc(:level).first
        order.isnow=true
        order.save
    end
    courier_order.order_time.save   
end

get :break_order do
    error=params[:error]
    error_info=ErrorInfo.new
    error_info.message=error
    courier_order=CourierOrder.find(params[:order_id])
    courier_order.error_info=error_info
    setting=OrderSetting.where(courier_account:params[:account]).first
    employee=courier_order.courier_employee
    courier_order.iscomplete=true
    courier_order.level=0
    if params[:type]=="first"
        error_info.courier_employee=employee
        reduce_time=courier_order.usetime-(Time.now-courier_order.created_at)/60+setting.order_interval
    elsif params[:type]=="store"
        error_info.store_id=params[:store]
        reduce_time=courier_order.usetime-(Time.now-courier_order.start_time)/60+courier_order.order_time.time_diff
    else
        error_info.customer_account_id=params[:customer_id]
        reduce_time=courier_order.usetime-(Time.now-courier_order.start_time)/60+courier_order.order_time.time_diff
    end
    other_order=employee.courier_orders.where(:level.gt=>courier_order.level)
    if other_order.size>=1
        employee.whenfree-=(reduce_time+setting.customer_vali_time).minute
        other_order.each do |order|
            order.level-=1
            order.start_time-=reduce_time
            if order.level==1
                order.isnow=true
            end
            order.save
        end
    else
        employee.isfree=true
    end 
    
    error_info.save
    courier_order.save
    employee.save
end

end
