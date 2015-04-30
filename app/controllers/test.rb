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
  @stores=@account.stores
  logger.info @account.stores
  render :store
end
get :product do
  @account=SupplierAccount.find(params[:id])
  @products=@account.products
  
  render :product
end
get :employee do
  @account=SupplierAccount.find(params[:id])
  @employee_accounts=SupplierAccount.where(supplier_account_id:@account._id)
  logger.info @employee_accounts.to_json
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
get :customer do
  render :customer,:layout=>false
end
get :product_store do

  @account=SupplierAccount.find(params[:id])
  @product_stores=ProductStore.where(store_id:params[:store_id])

  render :product_store
end



get :product_detail do
  product_details=Product.find(params[:id]).product_details
  product_details.to_json
end
get :stores do
   stores=SupplierAccount.find(params[:id]).stores
   stores.to_json
end
end
