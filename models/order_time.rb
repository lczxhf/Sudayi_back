class OrderTime
  include Mongoid::Document
  include Mongoid::Timestamps 
  #订单准确完成的时间

  belongs_to :courier_order

   field :store_time,:type=>DateTime                      #供应商确认时的时间
    field :interval_time,:type=>DateTime                 #订单间隔的准确时间
    field :courier_time,:type=>DateTime
    field :store_vali_time,:type=>Array               #仓库验货结束的时间
    field :customer_time,:type=>DateTime                #客户验货结束的时间
    field :first_node_way_time,:type=>Array        #从出发区到仓库后的时间
    field :end_node_way_time,:type=>DateTime        #仓库到客户所在区的时间
    field :real_complete_time,:type=>DateTime          #最终结束时间
    field :time_diff,:type=>Integer,:default=>0             #和预计时间相差的时间

end
