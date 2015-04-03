class ProductCache
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :node

  field :name,:type=>String
end
