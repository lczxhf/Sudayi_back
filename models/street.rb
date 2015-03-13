class Street
  include Mongoid::Document
  include Mongoid::Timestamps 
  #街道表

  belongs_to :area
 
  field :name,:type=>String
  field :code,:type=>String


end
