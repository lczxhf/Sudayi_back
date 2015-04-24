class StoreInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  belongs_to :store
  belongs_to :store_type

  field :open_time_begin_day, :type =>String
  field :open_time_end_day, :type =>String
  field :open_time_in_one_week, :type=>Array,:default=>[1,2,3,4,5,6,7]
  field :store_url, :type => String
  mount_uploader :store_url, ImageItemUpload
  field :manager_name,:type=>String                                                   #仓库管理员
  field :manager_phone,:type=>String
  field :validate_person,:type=>String                                              #认证员
  field :address_reminder,:type=>String    #地址提示
  field :end_date,:type=>Date
end
