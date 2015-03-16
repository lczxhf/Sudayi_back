class Cart
  include Mongoid::Document
  include Mongoid::Timestamps 
  #购物车

  belongs_to :order
  belongs_to :customer_account
  belongs_to :product_detail

  field :sum,:type=>Integer
  field :message,:type=>String


end
