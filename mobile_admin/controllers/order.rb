SudayiBack::MobileAdmin.controllers :order do
  
get :store_vali do
    courier_order=CourierOrder.find(params[:order_id])
    if courier_order.order_time
        courier_order.order_time.store_time=Time.now
        courier_order.order_time.save
    else
        courier_order.build_order_time(store_time:Time.now)
        courier_order.order_time.save
    end
end
  

end
