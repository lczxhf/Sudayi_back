class CourierStore
  include Mongoid::Document
  include Mongoid::Timestamps 
  #配送商货架表

  belongs_to :courier_account
  belongs_to :address
 
  field :name,:type=>String
  field :number,:type=>String

end
