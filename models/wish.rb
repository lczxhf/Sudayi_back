class Wish
  include Mongoid::Document
  include Mongoid::Timestamps
  #客户心愿表

  belongs_to :customer_account
  belongs_to :product
 
  field :message,:type=>String

end