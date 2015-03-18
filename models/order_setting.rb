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

  def  self.all_time(courier_account)
    setting=OrderSetting.where(courier_account_id:courier_account).first
    time=setting.store_time+setting.order_interval+setting.store_vali_time+setting.customer_vali_time
    return time
 end
 def  self.base_time(courier_account)
  setting=OrderSetting.where(courier_account_id:courier_account).first
    time=setting.store_time+setting.order_interval+setting.store_vali_time
    return time
 end
end
