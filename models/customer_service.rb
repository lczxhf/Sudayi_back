class CustomerService
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :product_detail
  belongs_to :customer_account
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>
  field :fee,:type=>Float
  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
