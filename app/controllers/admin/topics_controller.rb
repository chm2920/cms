#encoding: utf-8
class Admin::TopicsController < Admin::Backend
  
  def index
    @topics = Topic.paginate :page => params[:page], :per_page => 20, :conditions => "is_trash = 0", :order => "id desc"
  end

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
  end
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to [:admin, :topics]
    else
      render :action => "new"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    redirect_to [:admin, :topics]
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to [:admin, :topics]
  end
  
end
