class Product
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品表

  belongs_to :store                                                 #仓库id
  belongs_to :supplier_account
  belongs_to :state                                                 #商品认证状态
  belongs_to :category                                            #商品分类
  has_many :image_items
  has_many :product_details


   field :name, :type => String
  field :description, :type => String                               #商品描述
  field :level,  :type => Integer                                        #商品等级
  field :is_bring_three,:type=>Boolean                          #是否支持以一携三
  field :validate_person,:type=>String                             #认证员
  field :pay_types,:type=>Array                                         #商品支持的支付方式


def self.qcode(id)
    #二维码
    product = find(id)
    url = 'http://'+request.host+'get_product?pid='+id
    qr=RQRCode::QRCode.new(url)
    png=qr.to_img  # returns an instance of ChunkyPNG
    png.resize(300, 300).save('/home/ubuntu/sudayi_back/public/images/erweima/'+id+'.png')
  end

end 
