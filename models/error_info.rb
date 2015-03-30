class ErrorInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  #错误信息表   订单取消或者退货的信息存在这张表
  belongs_to :customer_account
  belongs_to :store
  belongs_to :courier_employee
  field :message,:type=>String
  
end
