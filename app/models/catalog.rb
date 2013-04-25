class Catalog < ActiveRecord::Base
  attr_accessible :cdir, :name, :parent_id, :sortrank
  
  belongs_to :parent_catalog, :class_name => "Catalog", :foreign_key => "parent_id"
  has_many :sub_catalogs, :class_name => "Catalog", :foreign_key => "parent_id", :dependent => :destroy
  
  has_many :topics, :dependent => :destroy
  
  def sub_catalog_ids
    ids = []
    ids << self.id
    if self.parent_id == 0
      self.sub_catalogs.each do |catalog|
        ids << catalog.id
        catalog.sub_catalogs.each do |sub_catalog|
          ids << sub_catalog.id
        end
      end
    else
      self.sub_catalogs.each do |catalog|
        ids << catalog.id
      end
    end
    ids
  end
  
end
