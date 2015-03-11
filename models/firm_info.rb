class FirmInfo
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
   belongs_to :address
   belongs_to :state
   belongs_to :firm_type
   belongs_to :supplier_account
  # field <name>, :type => <type>, :default => <value>
   field :firm_name,:type=>String
   field :legal_person,:type=>String
   field :business_license_number,:type=>String
   field :org_code,:type=>String
   field :url,:type=>String
   field :url2,:type=>String
   field :url3,:type=>String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
