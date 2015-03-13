class FriendMessage
  include Mongoid::Document
  include Mongoid::Timestamps 
  #朋友消息储存表

  belongs_to :customer_account                                          #发送消息的客户id

  field :to_customer,:type=>String                                         #接收消息的客户id
  field :message,:type=>String                   
  field :is_delete,:type=>Boolean,:default=>false               #消息是否被删除
  field :is_read,:type=>Boolean,:default=>false                   #消息是否已读

end
