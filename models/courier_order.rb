class CourierOrder
  include Mongoid::Document
  include Mongoid::Timestamps 
  #快递员订单表

  belongs_to :courier_employee                                              #订单的快递员id
  belongs_to :store                                                                      #订单的
  belongs_to :customer_account                                              #订单的客户id
  has_many :orders   
  has_one :back_order
  
  field :number,:type=>String                                                     #订单号
  field :iscomplete,:type=>Boolean,:default=>false                #订单是否完成
  field :isnow,:type=>Boolean,:default=>false                         #订单是否正在执行
  field :usetime,:type=>Integer,:default=>''                              #完成订单预计使用时间
  field :level,:type=>Integer                                                         #订单的等级
 
end
