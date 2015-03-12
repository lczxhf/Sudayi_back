class FriendMessage
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :customer_account
  # field <name>, :type => <type>, :default => <value>
  field :to_customer,:type=>String
  field :message,:type=>String
  field :is_delete,:type=>Boolean
  field :is_read,:type=>Boolean
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
