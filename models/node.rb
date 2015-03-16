class Node
  include Mongoid::Document
  include Mongoid::Timestamps 
  #自己分区的表
  belongs_to :city
  belongs_to :area                        #属于哪个区 例如罗湖区

  field :name,:type=>String
  field :code,:type=>String
  field :streets,:type=>Array


 def self.get_node_way(node_id)
    node=Node.find(node_id)
    node_ways=NodeWay.where(node_id:node._id)
    return node_ways
 end
 
end
