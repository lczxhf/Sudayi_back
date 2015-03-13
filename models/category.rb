class Category
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品的分类表

  belongs_to :category                        #分类属于分类! 例如牛仔裤属于裤子分类
  has_many :categories
  belongs_to :supplier_account

  field :name,:type=>String
  field :code,:type=>String

end
