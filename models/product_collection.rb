class ProductCollection
  include Mongoid::Document
  include Mongoid::Timestamps 
  #收藏商品表

  belongs_to :product                                         #商品id
  has_many :customer_account                        #客户id

   field :message,:type=>String                             #备注
  

end
