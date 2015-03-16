SudayiBack::Mobile.controllers :order do
use Rack::Cors do 
  allow do
    # put real origins here
    origins '*','null'
    # and configure real resources here
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

post :create_order, :csrf_protection=>false do
    @account = CourierAccount.find('54d4819fcc3007823d000001')
    node = @account.courier_address.node
    cart_arr=params[:cart].split(',')
    carts=[]
    cart_arr.each do |cart_id|
    	carts<<Cart.find(cart_id)
    end
    
end
  

end
