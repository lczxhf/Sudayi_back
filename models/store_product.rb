class StoreProduct
  include Mongoid::Document
  include Mongoid::Timestamps 
  #配送商货架存放商品信息表

  belongs_to :courier_store                 #供应商货架id
  belongs_to :product_detail                #某种规格商品的id

  field :message,:type=>String              #备注
  field :sum,:type=>Integer                    #数量

end
