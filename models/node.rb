class Node
  include Mongoid::Document
  include Mongoid::Timestamps 
  #自己分区的表
  belongs_to :city
  belongs_to :area                        #属于哪个区 例如罗湖区

  field :name,:type=>String
  field :code,:type=>String
  field :streets,:type=>Array


end
