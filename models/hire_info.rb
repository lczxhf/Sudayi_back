class HireInfo
  include Mongoid::Document
  include Mongoid::Timestamps 


 
   belongs_to :state                                                          #认证的状态
   belongs_to :supplier_account


   field :lessee_name,:type=>String                                   #公司名
   field :lessee_card,:type=>String                                #法人
   field :url,:type=>String
   mount_uploader :url, ImageItemUpload
   field :url2,:type=>String
   mount_uploader :url2, ImageItemUpload
   field :url3,:type=>String
   mount_uploader :url3, ImageItemUpload
   field :url4,:type=>String
   mount_uploader :url4, ImageItemUpload
   field :validate_person,:type=>String,:default=>'wu'                #认证员
 
 
end
