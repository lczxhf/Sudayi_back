class Detail
  include Mongoid::Document
  include Mongoid::Timestamps 
  #地址细节表  如区下面的由自己填写就是保存在这张表

  field :name,:type=>String

end
