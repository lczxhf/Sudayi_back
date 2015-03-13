class PayType
  include Mongoid::Document
  include Mongoid::Timestamps 
  #支付方式表
 
  field :name,:type=>String
  field :code,:type=>String

end
