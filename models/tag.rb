class Tag
  include Mongoid::Document
  include Mongoid::Timestamps 
  belongs_to :category
  belongs_to :state

field :name,:type=>String
end
