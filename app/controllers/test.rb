SudayiBack::App.controllers :test do
  
get :login do
  render :login
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
end
