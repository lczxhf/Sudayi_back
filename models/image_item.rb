class ImageItem
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :product
  # field <name>, :type => <type>, :default => <value>
   field :name, :type => String
   field :url, :type => String
   field :isdetail, :type => Boolean
   field :iscover, :type => Boolean
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
