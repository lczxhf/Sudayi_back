class Coupon
  include Mongoid::Document
  include Mongoid::Timestamps 
  #优惠券表
  belongs_to :product

  field :discount,:type=>Float
  field :message,:type=>String
  field :end_date,:type=>DateTime

end
