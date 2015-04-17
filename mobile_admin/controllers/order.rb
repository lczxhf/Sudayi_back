SudayiBack::MobileAdmin.controllers :order do
  
get :store_vali do
    courier_order=CourierOrder.find(params[:order_id])
    courier_order.order_time.store_time[params[:index].to_i]=Time.now
    number=courier_order.order_time.store_time[0]
    if number==(courier_order.order_time.store_time.size-1)&&!courier_order.order_time.store_time.include?(nil)&&courier_order.order_time.courier_time
        order=courier_order.orders.asc(:level).first
        order.isnow=true
        order.save
    end
end
  


end
