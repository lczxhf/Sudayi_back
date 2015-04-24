class StoreType
  include Mongoid::Document
  include Mongoid::Timestamps 


  field :name,:type=>String
  field :code,:type=>Integer
  field :message,:type=>String
end
