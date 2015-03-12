class ProductDetail
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
   belongs_to :product
  has_many :product_stores
  has_many :comments
  # field <name>, :type => <type>, :default => <value>
   field :specification,:type=>String
   field :price, :type => Float
   field :storage, :type => Integer
   field :no_store,:type=>Integer
   field :is_rec,:type=>Boolean
  # field <name>, :type => <type>, :default => <value>
  

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
