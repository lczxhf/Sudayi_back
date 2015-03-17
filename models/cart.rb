class Cart
  include Mongoid::Document
  include Mongoid::Timestamps 
  #购物车

  belongs_to :courier_order
  belongs_to :customer_account
  belongs_to :product_detail

  field :sum,:type=>Integer
  field :message,:type=>String
  field :is_complete,:type=>Boolean,:default=>false


end
