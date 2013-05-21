desc "rss get" 
task(:get_rss => :environment) do 
  def import_rss_from_url(url)    
    begin
      html = BaiduRssItem.get(url)
      items = []
      
      cdir = ""
      url.scan(/class=(.*?)&/) do |p|
        cdir = p[0]
      end    
      catalog = Catalog.find_by_cdir(cdir)
      last_url = ''
      if !catalog.extra.blank?
        last_url = catalog.extra
      end
        
      html.scan(/<item>(.*?)<\/item>/m) do |a|
        item = a[0].to_s
        rss_item = BaiduRssItem.new
        rss_item.extract(item)
        
        if rss_item.link == last_url
          break
        end
        if !rss_item.description.blank?
          items << rss_item
        end
      end
      if items.length > 0
        items.reverse!
        items.each do |item|
          item.save(catalog)
        end
        catalog.extra = items[items.length - 1].link
        catalog.save
      end
    rescue
      puts "error"
    else
    end
  end
  
  @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
  urls = []
  @catalogs.each do |catalog|
    catalog.sub_catalogs.each do |sub_catalog|
      if sub_catalog.sub_catalogs.length > 0
        sub_catalog.sub_catalogs.each do |sub_sub_catalog|
          urls << "http://news.baidu.com/n?cmd=4&class=" + sub_sub_catalog.cdir + "&tn=rss"
        end
      else
        urls << "http://news.baidu.com/n?cmd=4&class=" + sub_catalog.cdir + "&tn=rss"
      end
    end
  end
  
  l = urls.length.to_s
  File.open(File.expand_path(Rails.root + "log/rss.log", __FILE__), "a") do |log_file|
    log_file.puts "#{Time.now}====>start data."
    urls.each_with_index do |url, index|
      puts index.to_s + "/" + l + " " + url
      log_file.puts url
      import_rss_from_url(url)
    end
    log_file.puts "#{Time.now}====>end data."
  end
  
end 