class StoreEmployee
  include Mongoid::Document
  include Mongoid::Timestamps 
  #供应商员工表

  belongs_to :supplier_account
  belongs_to :store
  

  field :is_work,:type=>Boolean
  field :my_account,:type=>String

end
