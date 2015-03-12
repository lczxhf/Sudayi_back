class BackOrder
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :courier_order
  belongs_to :customer_account
  belongs_to :courier_store
  belongs_to :error_info
  # field <name>, :type => <type>, :default => <value>
   field :iscomplete,:type=>Boolean,:default=>false
  field :isnow,:type=>Boolean,:default=>false
  field :usetime,:type=>Integer,:default=>''
  field :level,:type=>Integer
  field :product_detail,:type=>Array
  field :sum,:type=>Array
  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
