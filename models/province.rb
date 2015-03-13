class Province
  include Mongoid::Document
  include Mongoid::Timestamps 
  #省 表

  belongs_to :country
  has_many :cities

  field :name,:type=>String
  field :code,:type=>String

 
end
