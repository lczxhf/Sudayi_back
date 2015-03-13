class Country
  include Mongoid::Document
  include Mongoid::Timestamps 
  #国家表

  has_many :provinces
 
  field :name,:type=>String
  field :code,:type=>String

  
end
