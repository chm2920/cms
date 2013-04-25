#encoding: utf-8
class Admin::TopicsController < Admin::Backend
  
  def index
    if !params[:topic_ids].nil?
      params[:topic_ids].each do |topic_id|
        topic = Topic.find(topic_id)
        topic.is_trash = 1
        topic.save
      end
    end
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
    if !params[:page].nil?
      @page = params[:page].to_i
    else
      @page = 1
    end
    if !params[:catalog_id].nil?
      @catalog = Catalog.find(params[:catalog_id])
      @topics = Topic.paginate :page => @page, :per_page => 20, :conditions => ["catalog_id in (?) and is_trash = 0", @catalog.sub_catalog_ids], :order => "id desc"
    else
      @topics = Topic.paginate :page => @page, :per_page => 20, :conditions => "is_trash = 0", :order => "id desc"
    end
  end
  
  def trashes
    if !params[:topic_ids].nil?
      Topic.destroy_all(["id in (?)", params[:topic_ids]])
    end
    @topics = Topic.paginate :page => params[:page], :per_page => 20, :conditions => "is_trash = 1", :order => "id desc"
  end

  def new
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
    @topic = Topic.new
  end

  def edit
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
    @topic = Topic.find(params[:id])
    @content = @topic.topic_addon.content
  end
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      @topic_addon = TopicAddon.new
      @topic_addon.topic = @topic
      @topic_addon.content = params[:content]
      @topic_addon.save
      redirect_to [:admin, :topics]
    else
      render :action => "new"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    @topic_addon = @topic.topic_addon
    @topic_addon.content = params[:content]
    @topic_addon.save
    redirect_to :action => :index, :page => params[:page]
  end
  
  def del
    @topic = Topic.find(params[:id])
    @topic.is_trash = 1
    @topic.save
    redirect_to :action => :index, :page => params[:page]
  end
  
  def repost
    @topic = Topic.find(params[:id])
    @topic.is_trash = 0
    @topic.save
    redirect_to [:admin, :topics, :trashes]
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to [:admin, :topics, :trashes]
  end
  
  def clear
    Topic.destroy_all(:is_trash => 1)
    redirect_to [:admin, :topics, :trashes]
  end
  
end
