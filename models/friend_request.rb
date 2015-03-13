class FriendRequest
  include Mongoid::Document
  include Mongoid::Timestamps 
  #申请好友表

  belongs_to :customer_account                              #想要加的客户id
  belongs_to :comment                                               #申请好友是根据哪条评论而加的

  field :form_customer,:type=>String                        #哪个客户申请的
  field :message,:type=>String
  field :is_delete,:type=>Boolean,:default=>false     #是否已被删除
  field :is_read,:type=>String,:default=>false             #是否已读
  field :is_accept,:type=>Boolean                                 #接受还是拒绝了
 
end
