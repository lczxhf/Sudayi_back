class StoreEmployee
  include Mongoid::Document
  include Mongoid::Timestamps 
  #供应商员工表

  belongs_to :supplier_account
  

  field :is_work,:type=>Boolean
  field :my_account,:type=>String

end
