class StartController < ApplicationController
  
  def index
    @new_topics = Topic.find(:all, :conditions => "is_trash = 0", :order => "id desc", :limit => 15)
  end  
  
  def gb
    case request.method
    when "POST"
      @gb = Guestbook.new(params[:gb])
      @gb.info = params[:gb][:info].to_json
      @gb.save
      render :gb_rst
    else
      @gb = Guestbook.new
    end
  end
  
  def ajs
    @ad = Ad.find(params[:id])
    if !@ad.nil?
      v = <<JAVASCRIPT
document.write("#{@ad.code}");
JAVASCRIPT
      render :text => v
    else
      render :text => ""
    end
  end
  
end
