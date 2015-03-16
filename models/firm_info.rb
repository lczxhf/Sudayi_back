class FirmInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  #企业认证表

   belongs_to :firm_address
   belongs_to :state                                                          #认证的状态
   belongs_to :firm_type                                                  #公司的类型
   belongs_to :supplier_account
   belongs_to :courier_account

   field :firm_name,:type=>String                                   #公司名
   field :legal_person,:type=>String                                #法人
   field :business_license_number,:type=>String         #营业执照
   field :org_code,:type=>String                                        #组织机构代码号
   field :url,:type=>String
   mount_uploader :url, ImageItemUpload
   field :url2,:type=>String
   mount_uploader :url2, ImageItemUpload
   field :url3,:type=>String
  mount_uploader :url3, ImageItemUpload
   field :validate_person,:type=>String,:default=>'wu'                #认证员
 
 #验证
  validates_presence_of   :firm_name,:legal_person,:business_license_number,:org_code,:url,:url2,:url3,:message=>'请将信息填写完整'
 

end
