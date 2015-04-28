class FirmInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  #企业认证表

   belongs_to :firm_address
   belongs_to :state                                                          #认证的状态
   belongs_to :firm_type                                                  #公司的类型
   belongs_to :supplier_account


   field :firm_name,:type=>String                                   #公司名
   field :legal_person,:type=>String                                #法人
   field :business_license_number,:type=>String         #营业执照
   field :legal_person_card,:type=>String                                        #组织机构代码号
   field :url,:type=>String
   mount_uploader :url, ImageItemUpload
   field :url2,:type=>String
   mount_uploader :url2, ImageItemUpload
   field :url3,:type=>String
   mount_uploader :url3, ImageItemUpload
   field :url4,:type=>String
   mount_uploader :url4, ImageItemUpload
   field :validate_person,:type=>String,:default=>'wu'                #认证员
  
  after_destroy do |abc|
      path=File.dirname(__FILE__)
      path=path[0..path.rindex('/')]+"public"
      Dir::delete(path+'/uploads/firm_info/'+abc._id)
  end
end
