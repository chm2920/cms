#encoding: utf-8
class Admin::CatalogsController < Admin::Backend
  
  def index
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
  end

  def new
    @catalog = Catalog.new
    if !params[:cid].nil?
      @pcatalog = Catalog.find(params[:cid])
      @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
    end    
  end
  
  def batch_new    
  end
  
  def batch_create
    if params[:catalog]
      params[:catalog].each do |key, val|
        if !val[:name].blank?
          catalog = Catalog.new
          catalog.parent_id = 0
          catalog.sortrank = key
          catalog.name = val[:name]
          catalog.cdir = val[:cdir]
          catalog.save
          if !val[:children].blank?
            children = val[:children].gsub("，", ',').split(',')
            0.upto children.length - 1 do |j|
              subcatalog = Catalog.new
              subcatalog.parent_id = catalog.id
              subcatalog.sortrank = j + 1
              subcatalog.name = children[j].strip
              subcatalog.save
            end
          end
        end
      end
    end
    redirect_to [:admin, :catalogs]
  end
  
  def batch_update
    if params[:catalog]
      params[:catalog].each do |key, val|
        catalog = Catalog.find(key)
        if catalog
          catalog.sortrank = val[:sortrank]
          catalog.name = val[:name]
          catalog.cdir = val[:cdir]
          catalog.save
        end
      end
    end
    redirect_to [:admin, :catalogs]
  end

  def edit
    @catalog = Catalog.find(params[:id])
    @catalogs = Catalog.all(:conditions => ["parent_id = 0 and id != ?", @catalog.id], :order => "sortrank asc, id asc")
  end
  
  def create
    @catalog = Catalog.new(params[:catalog])
    if @catalog.save
      redirect_to [:admin, :catalogs]
    else
      render :action => "new"
    end
  end

  def update
    @catalog = Catalog.find(params[:id])
    @catalog.update_attributes(params[:catalog])
    redirect_to [:admin, :catalogs]
  end

  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy
    redirect_to [:admin, :catalogs]
  end
  
  def clear
    @catalog = Catalog.find(params[:catalog_id])
    redirect_to [:admin, :catalogs]
  end
  
end
