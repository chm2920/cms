class CommentsController < ApplicationController
    
  def create
    @topic = Topic.find(params[:id])
    
    case request.method
    when "POST"
      @comment = Comment.new
      @comment.topic = @topic
      @comment.uname = ""
      @comment.ip = request.remote_ip
      @comment.content = params[:comment_content]
      @comment.save
    else
    end
    redirect_to @topic.show_url
  end
  
end
