SudayiBack::Courier.controllers :order do

get :store_vali do
    courier_order=CourierOrder.find(params[:order_id])
    if courier_order.order_time
        courier_order.order_time.courier_time=Time.now
        courier_order.order_time.save
    else
        courier_order.build_order_time(courier_time:Time.now)
        courier_order.order_time.save
    end
end

get :break_order do
    error=params[:error]
    error_info=ErrorInfo.new
    error_info.message=error
    courier_order=CourierOrder.find(params[:order_id])
    courier_order.error_info=error_info
    setting=OrderSetting.where(courier_account:params[:account]).first
    employee=courier_order.courier_employee
    if params[:type]=="first"
        courier_order.iscomplete=true
        reduce_time=courier_order.usetime+setting.store_time-(Time.now-courier_order.created_at)/60
        other_order=employee.courier_orders.where(:level.gt=>courier_order.level)
        if other_order.size>=1
            employee.whenfree-=reduce_time.minute
            other_order.each do |order|
                order.level-=1
                order.usetime-=reduce_time
                if order.level==1
                    order.isnow=true
                end
                order.save
            end
        else
            employee.isfree=true
        end 
        courier_order.level=0
    end
    error_info.save
    courier_order.save
    employee.save
end

end
