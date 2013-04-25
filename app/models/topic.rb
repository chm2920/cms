class Topic < ActiveRecord::Base
  
  attr_accessible :badpost, :catalog_id, :description, :goodpost, :hits, :keywords, :litpic, :source, :title, :writer, :is_trash
  
  
  belongs_to :catalog
  
  has_one :topic_addon
  
  def show_url
    "/topics/#{self.id}"
  end
  
end
