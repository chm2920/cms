class Topic < ActiveRecord::Base
  
  attr_accessible :badpost, :catalog_id, :description, :goodpost, :hits, :keywords, :litpic, :source, :title, :writer, :is_trash
  
  
  belongs_to :catalog
  
  has_one :topic_addon
  
  def show_url
    url = []
    catalog = self.catalog
    while catalog.parent_id != 0
      url << catalog.cdir
      catalog = catalog.parent_catalog
    end
    "/#{url.join('/')}/news-" + self.created_at.strftime("%Y%m%d") + "-#{self.id}.html"
  end
  
end
