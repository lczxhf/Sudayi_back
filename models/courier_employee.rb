class CourierEmployee
  include Mongoid::Document
  include Mongoid::Timestamps
  #快递员表

  belongs_to :courier_account
  has_many :courier_orders

  field :real_name,:type=>String
  field :email,:type=>String
  field :isfree,:type=>Boolean,:default=>true                     #快递员是否空闲
  field :whenfree,:type=>DateTime,:default=>''                 #快递员何时空闲
  field :number,:type=>String
  field :money,:type=>Float,:default=>0                               #快递员身上有多少钱
  field :product_details,:type=>Array,:default=>[]                                    #快递员身上有什么商品
  field :is_work,:type=>Boolean                                             #快递员是否上班了
  field :end_node,:type=>String,:default=>""
  field :my_account,:type=>String
 #验证
    validates_length_of            :email,    :within => 8..100
    validates_uniqueness_of   :email,    :case_sensitive => false
    validates_format_of            :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i ,:message=>'请输入正确的邮箱'
end
