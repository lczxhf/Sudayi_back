class NodeWay
  include Mongoid::Document
  include Mongoid::Timestamps 
  #区到区之间的距离表

  belongs_to :node                                   #始发区的id
 
  field :tonode,:type=>String                   #终点区的id
  field :fee,:type=>Float                           #始发区到终点区的费用
  field :time,:type=>Integer                    #始发区到终点区花费的时间
  field :miles,:type=>Float                       #两者之间的距离

 
end
