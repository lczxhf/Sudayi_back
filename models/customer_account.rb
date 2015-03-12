class CustomerAccount
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :address
  # field <name>, :type => <type>, :default => <value>
  field :username,:type=>String
  field :crypted_password,:type=>String
   field :real_name,:type=>String
   field :level,:type=>Integer
   field :mobile,:type=>String
   field :email,:type=>String
   field :other_address,:type=>Array

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
