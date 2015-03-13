class FirmType
  include Mongoid::Document
  include Mongoid::Timestamps 
  #公司类型表

  field :name,:type=>String
  field :code,:type=>String

end
