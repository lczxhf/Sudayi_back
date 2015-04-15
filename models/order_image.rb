class OrderImage
  include Mongoid::Document
  include Mongoid::Timestamps 

  belongs_to :order

  field :url1,:type=>String
  field :url2,:type=>String
  field :url3,:type=>String
  mount_uploader :url1, ImageItemUpload
  mount_uploader :url2, ImageItemUpload
  mount_uploader :url3, ImageItemUpload

end
