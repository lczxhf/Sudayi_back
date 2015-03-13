class OrderSetting
  include Mongoid::Document
  include Mongoid::Timestamps 
  #订单设置时间表

  belongs_to :courier_account

  field :store_time,:type=>Integer,:default=>5                        #仓库确定时间
  field :order_interval,:type=>Integer,:default=>5                   #订单间隔时间
  field :store_vali_time,:type=>Integer,:default=>5                  #在仓库验货时间
  field :customer_vali_time,:type=>Integer,:default=>10          #客户验货时间
  field :complete_after,:type=>String                                             #完成订单后行为

 
end
