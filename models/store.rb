class Store
  include Mongoid::Document
  include Mongoid::Timestamps 
  #供应商仓库表

  belongs_to :supplier_account
  belongs_to :state                                                                     #仓库认证状态
  belongs_to :store_address                                                               #仓库地址
  has_many :store_employee
  has_many :products
  has_many :orders

  field :name, :type => String
  field :open_time_begin_day, :type => String
  field :open_time_end_day, :type => String
  field :open_time_in_one_week, :type=> String
  field :credit_url, :type => String
  field :manager_id,:type=>String                                                   #仓库管理员
  field :is_open,:type=>Boolean                                                       #仓库是否开门
  field :validate_person,:type=>String                                              #认证员

end
