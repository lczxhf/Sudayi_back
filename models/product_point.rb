class ProductPoint
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品扣点表
  belongs_to :product
  belongs_to :courier_account

  field :discount,:type=>Float,:default=>1
  field :message,:type=>String

end
