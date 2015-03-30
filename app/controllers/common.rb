SudayiBack::App.controllers :common do

#返回某个区下的自定义区
get :get_node do
  nodes=Node.where(area_id:params[:area_id])
  nodes.to_json
end

#返回所有国家
get :country do
  Country.all.to_json
end  

#返回中国的所有省
get :province do
  if !params[:country_id]
    country=Country.where(name:'中国').first
    Province.where(country_id:country._id).to_json
  else
    Province.where(country_id:params[:country_id]).to_json
  end
end

#返回某个省下的所有城市
get :city do
  City.where(province_id:params[:province_id]).to_json
end 

#返回某个城市下的所有区
get :area do
  Area.where(city_id:params[:city_id]).to_json
end

#验证码
get :code_image do
  
  session[:noisy_image]=NoisyImage.new(4)  
  session[:code]=session[:noisy_image].code 
  image=session[:noisy_image].image  
  image
end  
get :test do
    tag=Tag.new
    if tag.name.nil?
      puts 'abc'
    else
      puts "cba"
    end
    tag.save
end
end
