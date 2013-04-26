class StartController < ApplicationController
  
  def index
    @new_topics = Topic.find(:all, :conditions => "is_trash = 0", :order => "id desc", :limit => 15)
  end
  
end
