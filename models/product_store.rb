class ProductStore
  include Mongoid::Document
  include Mongoid::Timestamps 
  #商品入库的信息表

  belongs_to :product_detail                          #某规格商品的id
  belongs_to :store                                            #仓库id

  field :amount,:type=>Integer                        #数量
  field :reserve,:type=>Integer,:default=>0             #被预定的数量
  field :is_up_shelve,:type=>Boolean,:default=>true

end
