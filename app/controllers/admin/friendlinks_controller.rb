class Admin::FriendlinksController < Admin::Backend
  
  def index
    @friendlinks = Friendlink.find(:all, :order => "rank asc")
  end
  
  def batch_update
    if params[:friendlink]
      params[:friendlink].each do |key, val|
        friendlink = Friendlink.find(key)
        if friendlink
          friendlink.rank = val[:rank]
          friendlink.title = val[:title]
          friendlink.link = val[:link]
          friendlink.save
        end
      end
    end
    redirect_to [:admin, :friendlinks]
  end

  def new
    @friendlink = Friendlink.new
  end

  def edit
    @friendlink = Friendlink.find(params[:id])
  end
  
  def create
    @friendlink = Friendlink.new(params[:friendlink])
    f = Friendlink.find_by_sql("select max(rank) as rank from friendlinks")
    @friendlink.rank = !f[0].rank.nil? ? (f[0].rank + 1) : 0
    if @friendlink.save
      redirect_to [:admin, :friendlinks]
    else
      render :action => "new"
    end
  end

  def update
    @friendlink = Friendlink.find(params[:id])
    @friendlink.update_attributes(params[:friendlink])
    redirect_to :action => :index
  end

  def destroy
    @friendlink = Friendlink.find(params[:id])
    @friendlink.destroy
    redirect_to [:admin, :friendlinks]
  end
  
end
