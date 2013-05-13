class Admin::GuestbooksController < Admin::Backend
  
  def index
    if !params[:guestbook_ids].nil?
      Guestbook.destroy_all(["id in (?)", params[:guestbook_ids]])
    end
    if !params[:page].nil?
      @page = params[:page].to_i
    else
      @page = 1
    end
    @guestbooks = Guestbook.paginate :page => @page, :per_page => 20, :order => "id desc"
  end

  def edit
    @guestbook = Guestbook.find(params[:id])
  end

  def update
    @guestbook = Guestbook.find(params[:id])
    @guestbook.reply = params[:reply]
    @guestbook.save
    redirect_to [:admin, :guestbooks], :page => params[:page]
  end

  def destroy
    @guestbook = Guestbook.find(params[:id])
    @guestbook.destroy
    redirect_to [:admin, :guestbooks]
  end
  
end
