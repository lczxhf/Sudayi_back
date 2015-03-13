class Area
  include Mongoid::Document
  include Mongoid::Timestamps 
  #区级表
  
  belongs_to :city
  has_many :streets
  has_many :nodes

  field :name,:type=>String
  field :code,:type=>String

end
