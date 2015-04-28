class Store
  include Mongoid::Document
  include Mongoid::Timestamps 
  #供应商仓库表

  belongs_to :supplier_account
  belongs_to :state                                                                     #仓库认证状态
  belongs_to :store_address,:dependent=>:delete                                                               #仓库地址
  has_many :store_employees
  has_many :products
  has_many :orders
  has_one :store_info,:dependent=>:delete


  field :name, :type => String
  field :is_open,:type=>Boolean,:default=>true                                                       #仓库是否开门

  before_destroy do |abc|
    path=File.dirname(__FILE__)
    path=path[0..path.rindex('/')]+"public"

    File::delete(path+abc.store_info.store_url.url)
    File::delete(path+abc.store_info.store_url.thumb.to_s)
    Dir::delete(path+'/uploads/store_info/'+abc.store_info._id)

  end
  def set_store_info(info,account_id,state_id,url,url2,url3,url4)
    puts info.to_json
      info.url=url
      info.url2=url2
      info.url3=url3
      info.url4=url4
      info.supplier_account_id=account_id
      info.state_id=state_id
      info.save

  end
end
