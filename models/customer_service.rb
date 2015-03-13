class CustomerService
  include Mongoid::Document
  include Mongoid::Timestamps 
  #客户做客服的表

  belongs_to :product_detail			#客户购买了哪种规格的商品后才做的客服
  belongs_to :customer_account		#客户的id
  
  field :fee,:type=>Float				#客户做客服后,给了他多少钱
  
end
