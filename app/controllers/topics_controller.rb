class TopicsController < ApplicationController
    
  def show
    @topic = Topic.find(params[:id])
    arr = @topic.source.split("##")
    @source = arr[0]
    if arr.length > 1
      @source_url = arr[1]
    end
    @catalog = @topic.catalog
    @catalog_topics = Topic.find(:all, :conditions => ["catalog_id = ?", @catalog.id], :order => "hits desc", :limit => 10)
    @month_topics = Topic.find(:all, :conditions => ["catalog_id = ?", @catalog.id], :order => "hits desc", :limit => 10)
    
    @sys_setting = SysSetting.find_by_stype("article_mix")
    @mixs = @sys_setting.setting.split("#,")
    
    @comments = Comment.paginate :page => params[:page], :per_page => 20, :conditions => ["topic_id = ?", @topic.id], :order => "id desc"
    
    @title = @topic.title
    @keywords = @topic.keywords
    @desc = @topic.description
  end
  
end
