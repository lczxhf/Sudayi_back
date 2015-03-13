class State
  include Mongoid::Document
  include Mongoid::Timestamps 
  #各种状态表

  field :name,:type=>String
  field :code,:type=>String

 
end
