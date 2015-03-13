class ImageItem
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品的图片集合表

  belongs_to :product                                 #商品id
  belongs_to :product_detail
  
   field :name, :type => String                           
   field :url, :type => String
   mount_uploader :url, ImageItemUpload
   field :isdetail, :type => Boolean            #是否是细节图
   field :iscover, :type => Boolean             #是否是封面图
   field :level,:type=>Integer                      #图片显示的排序
end
