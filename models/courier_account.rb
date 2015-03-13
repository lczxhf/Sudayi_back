class CourierAccount
  include Mongoid::Document
  include Mongoid::Timestamps 
  #配送商的账号表

  attr_accessor :password, :password_confirmation

  belongs_to :address
  has_one :credit_info
  has_one :firm_info
  has_many :courier_employees
  has_one :order_setting
  has_one :courier_website
 
  field :user_name,:type=>String
  field :crypted_password,:type=>String
  field :mobile,:type=>String
  field :level,:type=>Integer                                           #配送商的等级
  field :account_id,:type=>String                                   #员工的最高级用户的id 例如员工、管理员的最高级用户id都是老板的id
 
#验证
  validates_presence_of     :mobile, :level
  validates_length_of          :mobile,:is=>11  ,:message=>'请输入正确的手机号码'
  validates_presence_of     :password,                              :if => :password_required
  validates_presence_of     :password_confirmation,     :if => :password_required
  validates_length_of          :password, :within => 6..30, :if => :password_required,:message=>'密码必须在6-30个字符之间'
  validates_confirmation_of :password,                            :if => :password_required,:message=>'两次输入的密码不一致'
  validates_uniqueness_of   :mobile

#回调
  before_save :encrypt_password, :if => :password_required

#验证手机、密码是否正确的方法
  def self.authenticate_mobile(mobile, password)
    account = where(:mobile=> mobile).first 
    account && account.has_password?(password)  ? account : nil
  end

#验证密码是否正确的方法
  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private
#加密密码
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(self.password)
  end

  def password_required
    crypted_password.blank? || self.password.present?
  end  

end
