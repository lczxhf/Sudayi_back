class BackOrder
  include Mongoid::Document
  include Mongoid::Timestamps 
  #快递员返回公司的订单表

  belongs_to :courier_order
  belongs_to :customer_account
  belongs_to :courier_store
  belongs_to :error_info
 
  field :iscomplete,:type=>Boolean,:default=>false  #是否完成 字段
  field :isnow,:type=>Boolean,:default=>false           #是否现在执行 字段
  field :usetime,:type=>Integer,:default=>''                #订单将使用的时间(分钟)
  field :level,:type=>Integer                                           #订单的排列的等级
  field :product_detail,:type=>Array                             #执行此订单时 快递员携带的商品的规格id
  field :sum,:type=>Array                                               #执行此订单时 快递员携带的某规格商品的数量

end
