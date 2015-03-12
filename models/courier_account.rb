class CourierAccount
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  has_one :credit_info
  has_one :firm_info
  has_many :courier_employees
  has_one :order_setting
  has_one :courier_website
  # field <name>, :type => <type>, :default => <value>
  field :user_name,:type=>String
  field :crypted_password,:type=>String
  field :mobile,:type=>String
  field :level,:type=>Integer
  field :account_id,:type=>String
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
