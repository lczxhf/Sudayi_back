class City
  include Mongoid::Document
  include Mongoid::Timestamps 
  #城市表

  belongs_to :province
  has_many :areas
  has_many :node

  field :name,:type=>String
  field :code,:type=>String

end
