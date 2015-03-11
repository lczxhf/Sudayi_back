class CourierEmployee
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :courier_account
  has_many :orders
  # field <name>, :type => <type>, :default => <value>
  field :real_name,:type=>String
  field :email,:type=>String
  field :isfree,:type=>Boolean,:default=>true
 field :whenfree,:type=>DateTime,:default=>''
 field :number,:type=>String
 field :money,:type=>Float,:default=>0
 field :goods,:type=>Integer,:default=>0
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
