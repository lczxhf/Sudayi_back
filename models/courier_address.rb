class CourierAddress
  include Mongoid::Document
  include Mongoid::Timestamps 

  belongs_to :country
  belongs_to :province
  belongs_to :city
  belongs_to :area
  belongs_to :detail
  belongs_to :node
end
