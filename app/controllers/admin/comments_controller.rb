#encoding: utf-8
class Admin::CommentsController < Admin::Backend
  
  def index
    if !params[:comment_ids].nil?
      Comment.destroy_all(["id in (?)", params[:comment_ids]])
    end
    @comments = Comment.paginate :page => params[:page], :per_page => 20, :order => "id desc"
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to [:admin, :comments]
  end  
  
end
