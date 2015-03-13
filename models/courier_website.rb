class CourierWebsite
  include Mongoid::Document
  include Mongoid::Timestamps #
  belongs_to :courier_account
  
end
