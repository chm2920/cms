class Topic < ActiveRecord::Base
  
  attr_accessible :badpost, :catalog_id, :description, :goodpost, :hits, :keywords, :litpic, :source, :title, :writer, :is_trash
  
  
  belongs_to :catalog
  
  has_one :topic_addon
  
  has_many :comments
  
  def show_url
    urls = []
    catalog = self.catalog
    while catalog
      urls << catalog.cdir
      catalog = catalog.parent_catalog
    end
    "/#{urls.reverse.join('/')}/news-" + self.created_at.strftime("%Y%m%d") + "-#{self.id}.html"
  end
  
end
