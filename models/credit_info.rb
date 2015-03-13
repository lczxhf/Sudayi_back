class CreditInfo
  include Mongoid::Document
  include Mongoid::Timestamps 
  #个人认证表

  belongs_to :state                                                                                 #此认证的状态 
  belongs_to :supplier_account
  belongs_to :courier_account
 
  field :name, :type => String
  field :email, :type => String
  field :card_id, :type => String                                                              #身份证号码
  field :url, :type => String
  mount_uploader :url, ImageItemUpload
  field :url2, :type =>String
  mount_uploader :url2, ImageItemUpload
  field :url3,:type=>String
  mount_uploader :url3, ImageItemUpload
  field :validate_person,:type=>String,:default=>"wu"                      #认证员的id

#验证
  validates_presence_of   :name,:card_id,:url,:url2,:url3,:message=>'请将信息填写完整'
  validates_length_of       :card_id,:within=>18..19,:message=>'请输入正确的身份证号码'
  validates_length_of       :email,    :within => 8..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i ,:message=>'请输入正确的邮箱'
end
