class Catalog < ActiveRecord::Base
  attr_accessible :cdir, :name, :parent_id, :sortrank
  
  belongs_to :parent_catalog, :class_name => "Catalog", :foreign_key => "parent_id"
  has_many :sub_catalogs, :class_name => "Catalog", :foreign_key => "parent_id", :dependent => :destroy
  
  has_many :topics, :dependent => :destroy
  
end
