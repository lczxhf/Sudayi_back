class ErrorInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  #错误信息表   订单取消或者退货的信息存在这张表

  field :message,:type=>String
  
end
