class CourierOrder
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :courier_employee
  belongs_to :store
  belongs_to :customer_account
  has_many :orders   
  has_one :back_order
  # field <name>, :type => <type>, :default => <value>
   field :number,:type=>String
   field :iscomplete,:type=>Boolean,:default=>false
  field :isnow,:type=>Boolean,:default=>false
  field :usetime,:type=>Integer,:default=>''
  field :level,:type=>Integer
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
