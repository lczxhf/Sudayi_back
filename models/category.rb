class Category
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品的分类表

  belongs_to :category                        #分类属于分类! 例如牛仔裤属于裤子分类
  has_many :categories
  belongs_to :supplier_account

  field :name,:type=>String
  field :code,:type=>String


def self.judgeLeaf(cate)
      category = where(:category_id => cate).first
      category ? category :nil
  end

  def self.findLeaves(cate,arr,isfirst)
  	#广度优先算法检索分类
  	output_arr = arr
  	categories = where(:category_id => cate)
  	if categories
                if isfirst
  	     output_arr.push(find(cate)._id)
                end
  	   categories.each do |cate|
  	   output_arr.push(cate._id)
  	   category=judgeLeaf(cate._id)
  	   if category
  	          findLeaves(cate._id,output_arr,false)
                        next 
                 else
                        next
  	   end
  	   end
  	else

  	end
  end

  
end
