class Comment
  include Mongoid::Document
  include Mongoid::Timestamps 
  #评论表

  belongs_to :courier_order                                   
  belongs_to :product_detail                                 #评论的商品规格id
  belongs_to :customer_account                          #评论的用户id
  
  field :message,:type=>String                  
  field :comment_type,:type=>String                   #评论的等级,            如好评、差评
  field :url,:type=>String                                         #评论时上传的照片 如买家秀
  mount_uploader :url, ImageItemUpload
  field :is_delete,:type=>Boolean                          #评论是否删除
  
end
