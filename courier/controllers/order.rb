SudayiBack::Courier.controllers :order do

get :courier_vali do
    courier_order=CourierOrder.find(params[:order_id])
    courier_order.order_time.courier_time=Time.now
    number=courier_order.order_time.store_time[0]
    if number==(courier_order.order_time.store_time.size-1)&&!courier_order.order_time.store_time.include?(nil)
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
    error_info.courier_account=employee.courier_account
    courier_order.iscomplete=true
 #   courier_order.level=0
    end_node=""
    if params[:type]=="first"
        error_info.courier_employee=employee
        reduce_time=courier_order.usetime-(Time.now-courier_order.created_at)/60+setting.order_interval
        if courier_order.isnow
            end_node=courier_order.orders.asc(:level).first.first_node
        else
            end_node=CourierOrder.where(level:courier_order.level-1).first.orders.desc(:level).first.end_node
        end
    elsif params[:type]=="store"
        error_info.store_id=params[:store]
        reduce_time=courier_order.usetime-(Time.now-courier_order.start_time)/60+courier_order.order_time.time_diff
        end_node=courier_order.orders.where(store_id:params[:store]).first.store_address.node._id
        employee.end_node=end_node
    else
        error_info.customer_account_id=params[:customer_id]
        reduce_time=0
        employee.end_node=courier_order.address.node._id
    end

    other_order=employee.courier_orders.where(:level.gt=>courier_order.level)
    if other_order.size>=1
        other_order.each do |order|
            order.level-=1
            
            if order.level==1
                order.isnow=true
                if reduce_time!=0
                    node=order.orders.asc(:level).first.first_node
                    new_time=NodeWay.where(node_id:end_node,tonode:node).first.time
                    old_time=NodeWay.where(node_id:courier_order.orders.desc(:level).first.end_node,tonode:node).first.time
                    reduce_time=reduce_time-old_time+new_time
                end
            end
            order.start_time-=reduce_time.minute
            order.save
        end
        employee.whenfree-=reduce_time.minute
        if reduce_time!=0
            employee-=setting.customer_vali_time.minute
        end
    
    else
        employee.isfree=true
    end 
    courier_order.level=0
    courier_order.isnow=false
    error_info.save
    courier_order.save
    employee.save
end


get :store_vali do
  if params[:order_id]&&params[:number]  
   if params[:number].to_i==(params.size-1)/2
    order=Order.find(params[:order_id])
    courier_order=order.courier_order
    employee=courier_order.courier_employee
    employee.end_node=order.store_address.node
    employee.product_details+=order.product_detail
    employee.sum+=order.sum
    next_order=courier_order.orders.where(level:order.level+1).first
    order.isnow=false
    if next_order
        next_order.isnow=true
        courier_order.order_time.store_node_way_time<<Time.now
        courier_order.order_time.time_diff+=(Time.now-(courier_order.start_time+order.usetime.minute))/60
        index=1
        (params[:number].to_i).each do |a|
            order_image=OrderImage.new
            if params["url"+index.to_s]
                order_image.url1=params["url"+index.to_s]
                index+=1
            end
            if params["url"+index.to_s]
                order_image.url2=params["url"+index.to_s]
                index+=1
            end
            if params["url"+index.to_s]
                order_image.url3=params["url"+index.to_s]
                index+=1
            end
            order_image.order=order
            order_image.save
        end
        order.save
        next_order.save
        employee.save
        courier_order.order_time.save
    end
   end 
  end 
end

get :customer_vali do
    order=Order.find(params[:order_id])
    courier_order=order.courier_order
    employee=courier_order.courier_employee
    order.iscomplete=true
    order.isnow=false
    courier_order.iscomplete=true
    courier_order.isnow=false
    other_orders=employee.courier_orders.where(:level.gt=>courier_order.level)
    if !other_orders.empty?
        other_orders.each do |other_order|
            other_order.level-=1
            if other_order.level==1
                other_order.isnow=true
                a=other_order.orders.asc(:level).first
                a.isnow=true
                a.save
            end
            other_order.save
        end
    else
        employee.isfree=true
        employee.whenfree=""
    end
    employee.end_node=order.end_node
    courier_order.level=0
    courier_order.save
    employee.save
    order.save


end

end
