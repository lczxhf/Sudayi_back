class Order
  include Mongoid::Document
  include Mongoid::Timestamps 
  #取 送订单表

  belongs_to :courier_order                                                     #快递员id
  belongs_to :error_info                                                            
  belongs_to :pay_type                                                              #支付方式

  field :iscomplete,:type=>Boolean,:default=>false               #是否完成
  field :isnow,:type=>Boolean,:default=>false                       #是否正在执行
  field :usetime,:type=>Integer,:default=>''                            #此订单使用时间
  field :level,:type=>Integer                                                        #订单的等级
  field :order_type,:type=>String                                                 #订单是取还是送
  field :product_detail,:type=>Array                                          #订单的商品的规格
  field :sum,:type=>Array                                                             #数量
  field :first_node,:type=>String                                                   #始发区id
  field :end_node,:type=>String                                                   #终点区id

end
