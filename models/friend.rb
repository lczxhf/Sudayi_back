class Friend
  include Mongoid::Document
  include Mongoid::Timestamps 
  #朋友表

  belongs_to :customer_account                                              #客户的id
 
  field :to_customer,:type=>String                                            #另一个客户的id
  field :is_delete,:type=>Boolean,:default=>false                  #朋友关系是否被删除

end
