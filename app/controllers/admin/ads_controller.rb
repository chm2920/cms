class Admin::AdsController < Admin::Backend
  
  def index
    @ads = Ad.all(:order => "id desc")
  end

  def new
    @ad = Ad.new
  end

  def edit
    @ad = Ad.find(params[:id])
    @info = JSON.parse(@ad.info)
    case @ad.ad_type
    when "pic", "flash"
      @size = JSON.parse(@ad.size)
    else
      @size = {}
    end
  end
  
  def create
    @ad = Ad.new(params[:ad])
    g_html(params)
    
    if @ad.save
      redirect_to [:admin, :ads]
    else
      render :action => "new"
    end
  end

  def update
    @ad = Ad.find(params[:id])
    @ad.title = params[:ad][:title]
    @ad.mark = params[:ad][:mark]
    @ad.ad_type = params[:ad][:ad_type]
    g_html(params)
    
    if @ad.save
      redirect_to [:admin, :ads]
    else
      render :action => "edit"
    end
  end

  def destroy
    @ad = Ad.find(params[:id])
    @ad.destroy
    redirect_to [:admin, :ads]
  end
  
private

  def g_html(params)    
    ad_type = params[:ad][:ad_type]
    case ad_type
    when "pic"
      @ad.size = params[:ad][:size][ad_type.to_sym].to_json
      @ad.info = params[:ad][:info][ad_type.to_sym].to_json
      @ad.code = <<HTML
<div class="s_rad_#{@ad.mark}">
<a href="#{params[:ad][:info][:pic][:p_url]}" title="#{params[:ad][:info][:pic][:p_desc]}">
<img src="#{params[:ad][:info][:pic][:p_src]}" alt="#{params[:ad][:info][:pic][:p_desc]}" style="width:#{params[:ad][:size][:pic][:p_width]}px;height:#{params[:ad][:size][:pic][:p_height]}px;" />
</a>
</div>
HTML
    when "flash"
      @ad.size = params[:ad][:size][ad_type.to_sym].to_json
      @ad.info = params[:ad][:info][ad_type.to_sym].to_json
      @ad.code = <<HTML
<div class="s_rad_#{@ad.mark}">

</div>
HTML
    when "word"
      @ad.size = ""
      @ad.info = params[:ad][:info][ad_type.to_sym].to_json
      @ad.code = <<HTML
<div class="s_rad_#{@ad.mark}">
<a href="#{params[:ad][:info][:word][:w_url]}" title="#{params[:ad][:info][:word][:w_w]}" style="text-align:center;font-size:#{params[:ad][:info][:word][:w_size]};color:#{params[:ad][:info][:word][:w_color]};">
#{params[:ad][:info][:word][:w_w]}
</a>
</div>
HTML
    when "code"
      @ad.code = params[:ad_info_code]
    else
    end
  end
  
end
