class CatalogsController < ApplicationController
  
  def list
    @catalog = Catalog.find_by_cdir(params[:catalog_cdir])
    @sub_catalogs = @catalog.sub_catalogs
    if @sub_catalogs.length == 0
      render_show
      render :action => :show
    else
      sub_catalog_ids = @sub_catalogs.map{|c|c.id}
      @catalog_topics = Topic.find(:all, :conditions => ["catalog_id in (?)", sub_catalog_ids], :order => "hits desc, id desc", :limit => 10)
      @month_topics = Topic.find(:all, :conditions => ["catalog_id in (?)", sub_catalog_ids], :order => "hits desc, id desc", :limit => 10)
    end
    
    @title = @catalog.name
    @keywords = @catalog.name
    @desc = @catalog.name
  end
  
  def show
    @catalog = Catalog.find_by_cdir(params[:catalog_cdir])
    render_show
    
    @title = @catalog.name
    @keywords = @catalog.name
    @desc = @catalog.name
  end
  
private
  
  def render_show
    @topics = Topic.paginate :page => params[:page], :per_page => 20, :conditions => "catalog_id = #{@catalog.id}", :order => "id desc"
    @catalog_topics = Topic.find(:all, :conditions => ["catalog_id = ?", @catalog.id], :order => "hits desc, id desc", :limit => 10)
    @month_topics = Topic.find(:all, :conditions => ["catalog_id = ?", @catalog.id], :order => "hits desc, id desc", :limit => 10)
  end
  
end
