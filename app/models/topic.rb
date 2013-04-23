class Topic < ActiveRecord::Base
  
  attr_accessible :badpost, :catalog_id, :description, :goodpost, :hits, :keywords, :litpic, :source, :title, :writer, :is_trash
  
  
  belongs_to :catalog
  
end
