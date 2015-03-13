class ProductDetail
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品规格表

   belongs_to :product                                                #商品id
   has_many :product_stores                                      
   has_many :comments
   has_many :coustomer_services                            #客服

   field :specification,:type=>String                           #规格
   field :price, :type => Float
   field :storage, :type => Integer                                #库存
   field :no_store,:type=>Integer                                #此规格商品还有多少没加入仓库
   field :is_rec,:type=>Boolean                                    #此规格是否是推荐

end
