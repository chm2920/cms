class Admin::MoBrandsController < Admin::Backend
  
  def index
    if !params[:mo_brand_ids].nil?
      MoBrand.destroy_all(["id in (?)", params[:mo_brand_ids]])
    end
    @mo_brands = MoBrand.paginate :page => params[:page], :per_page => 15, :order => "id desc"
  end

  def new
    @mo_brand = MoBrand.new
  end

  def edit
    @mo_brand = MoBrand.find(params[:id])
  end
  
  def create
    @mo_brand = MoBrand.new(params[:mo_brand])
    if @mo_brand.save
      redirect_to [:admin, :mo_brands]
    else
      render :action => "new"
    end
  end

  def update
    @mo_brand = MoBrand.find(params[:id])
    @mo_brand.update_attributes(params[:mo_brand])
    redirect_to [:admin, :mo_brands]
  end

  def destroy
    @mo_brand = MoBrand.find(params[:id])
    @mo_brand.destroy
    redirect_to [:admin, :mo_brands]
  end
  
end
