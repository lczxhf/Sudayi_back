SudayiBack::App.controllers :test do
  
get :login do
  render :login,:layout=>false
end
get :home do
  @account=SupplierAccount.find(params[:id])
  render :home
end
get :store do
  @account=SupplierAccount.find(params[:id])
  render :store
end
get :product do
  @account=SupplierAccount.find(params[:id])
  render :product
end
get :employee do
  @account=SupplierAccount.find(params[:id])
  render :employee
end
get :product_upload do
  @account=SupplierAccount.find(params[:id])
  render :product_upload
end
get :product_tag do
  @account=SupplierAccount.find(params[:id])
  render :product_tag
end
get :now_order do
  @account=SupplierAccount.find(params[:id])
  render :now_order
end
get  :complete_order do
  @account=SupplierAccount.find(params[:id])
  render :complete_order
end
get :cancel_order do
  @account=SupplierAccount.find(params[:id])
  render :cancel_order
end
get :back_goods do
  @account=SupplierAccount.find(params[:id])
  render :back_goods
end
get :add_store do
  @account=SupplierAccount.find(params[:id])
  @nodes=Node.all
  render :add_store
end

end