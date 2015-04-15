class Order
  include Mongoid::Document
  include Mongoid::Timestamps 
  #取 送订单表

  belongs_to :courier_order                                      #快递员id                                                            
  belongs_to :pay_type                                           #支付方式
  belongs_to :store   
  belongs_to :store_employee                                                        

  field :iscomplete,:type=>Boolean,:default=>false               #是否完成
  field :isnow,:type=>Boolean,:default=>false                    #是否正在执行
  field :usetime,:type=>Integer,:default=>''                     #此订单使用时间
  field :level,:type=>Integer,:default=>0                        #订单的等级
  field :order_type,:type=>String                                #订单是取还是送
  field :product_detail,:type=>Array,:default=>[]                #订单的商品的规格
  field :discount,:type=>Array,:default=>[]                      #优惠券
  field :sum,:type=>Array,:default=>[]                            #数量
  field :first_node,:type=>String                                #始发区id
  field :end_node,:type=>String                                  #终点区id


def  self.get_now_node (order_id)
  order=Order.find(order_id)
  time=order.created_at+order.usetime.minute
    if order.order_time
      if order.order_time.time_diff!=0
    time+=order.order_time.time_diff.minute
  end
  end
    surplus=(time.to_i-Time.now.to_i)/60
    setting=Setting.last
   node_way=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first.time
 node=[]

  if surplus<setting.customer_vali_time
        node<<order.node.name+'(客户区)'
  nextorder=order.employee.orders.where(level:order.level+1).first
     if nextorder
  node<<Node.find(nextorder.firstnode).name
        else
          node<<order.employee.account.node.name
      end
 elsif surplus<(node_way+setting.customer_vali_time+setting.store_vali_time)
    
    node<<order.store.node.name+'(仓库区)'
    node<<order.node.name+'(客户区)'
  else
   
     node<< Node.find(order.firstnode).name+"(始发区)"
     node<<order.store.node.name+'(仓库区)'
  end

  return node
end
def self.get_start_time(order_id)
 setting=Setting.last
 order=Order.find(order_id)
 node_way1=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first
 node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first
time=(order.created_at+order.usetime.minute)-(node_way1.time+node_way2.time+setting.store_time+setting.store_vali_time+setting.customer_vali_time).minute

return time
  end

  def self.get_now_process(number,order_id)
      order=Order.find(order_id)
  time=order.created_at+order.usetime.minute
    if order.order_time
      if order.order_time.time_diff!=0
    time+=order.order_time.time_diff.minute
  end
  end
    surplus=(time.to_i-Time.now.to_i)/60
    setting=Setting.last
   node_way2=NodeWay.where(node_id:order.store.node._id,tonode:order.node._id).first.time
   node_way1=NodeWay.where(node_id:order.firstnode,tonode:order.store.node._id).first.time
   compare=0
   if surplus<0
    compare=6
     elsif surplus<=setting.customer_vali_time
     compare=5
     elsif surplus<=node_way2+setting.customer_vali_time
      compare=4
    elsif  surplus<=node_way2+setting.customer_vali_time+setting.store_vali_time
      compare=3
    elsif surplus<=node_way2+setting.customer_vali_time+setting.store_vali_time+node_way1
      compare=2
     elsif surplus<=node_way2+setting.customer_vali_time+setting.store_vali_time+node_way1+setting.store_time
  compare=1
    end
    if number<=compare
      return true
    else
      return false
    end

  end
end
