class Product
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :store
  belongs_to :supplier_account
  belongs_to :state
  belongs_to :pay_type
  belongs_to :category
  has_many :image_items
  has_many :product_collections
  # field <name>, :type => <type>, :default => <value>
   field :name, :type => String
  field :description, :type => String
  field :level,  :type => Integer

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
