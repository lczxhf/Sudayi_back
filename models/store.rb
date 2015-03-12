class Store
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :supplier_account
  has_many :orders
  belongs_to :state
  belongs_to :address
  has_many :store_employee
  has_many :products
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :in_charge, :type => String
  field :open_time_begin_day, :type => String
  field :open_time_end_day, :type => String
  field :open_time_in_one_week, :type=> String
  field :credit_url, :type => String
  field :manager_id,:type=>String
  field :is_open,:type=>Boolean
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
