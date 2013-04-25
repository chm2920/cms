class StartController < ApplicationController
  
  def index
    @topics = Topic.all
  end
  
end
