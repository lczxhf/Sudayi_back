class Bill
  include Mongoid::Document
  include Mongoid::Timestamps 

 field :name,:type=>String
 field :code,:type=>String
 field :message,:type=>String
end
