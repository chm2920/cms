#encoding: utf-8
class Admin::SeaController < Admin::Backend
  
  def rss
    if !params[:url].nil?
      begin
        @items = rss_parser(params[:url])
      rescue
        @items = "error"
      else
        
      end
    end
  end
  
  def import_rss
    import_rss_from_url(params[:url])
    redirect_to [:admin, :topics]
  end

  def auto
    @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")    
  end

  def auto_result
    case request.method
    when "POST"
      if !params[:urls].nil?
        @err_urls = []
        @err_titles = []
        
        threads = []
        params[:urls].each do |url|
          # threads << Thread.new(url) do |u|
            # u = u.to_s
            url = url.to_s
            puts "begin --> " + url
            import_rss_from_url(url)
          # end
        end
        # threads.each{|thr|thr.join}
      end
    else
      redirect_to [:admin, :sea, :auto]
    end    
  end
  
private

  def rss_parser(url) 
    items = []      
    begin
      html = BaiduRssItem.get(url)  
      
      cdir = ""
      url.scan(/class=(.*?)&/) do |p|
        cdir = p[0]
      end    
      catalog = Catalog.find_by_cdir(cdir)
      last_url = ''
      if !catalog.extra.blank?
        last_url = catalog.extra
      end
      
      is_new = "1"
      html.scan(/<item>(.*?)<\/item>/m) do |a|
        item = a[0].to_s
        rss_item = BaiduRssItem.new
        rss_item.extract(item)
        if rss_item.link == last_url
          is_new = "0"
        end
        rss_item.is_new = is_new
        items << rss_item
      end
    rescue
      puts 'error - ' + url
    else
    end
    
    items  
  end
  
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
        
      File.open(File.expand_path(Rails.root + "log/rss.log", __FILE__), "w+") do |log_file|      
        log_file.puts "#{Time.now}====>start data."
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
            log_file.puts item.title
            item.save(catalog)
          end
          catalog.extra = items[items.length - 1].link
          catalog.save
        end
        log_file.puts "#{Time.now}====>end data."
      end
    rescue
      puts 'error - ' + url
    else
    end
  end
  
end


__END__



  def rss_parser(url)
    require 'rexml/document'
    require 'open-uri'
    html = open(URI.parse(url)).read
    puts html
    
    xml = REXML::Document.new html
    
    puts '=='
    data = {
      :title    => xml.root.elements['channel/title'].text,
      :home_url => xml.root.elements['channel/link'].text,
      :rss_url  => url,
      :items    => []
    }
    xml.elements.each '//item' do |item|
      puts item
      new_items = {}
      item.elements.each do |e|
        new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
      end
      data[:items] << new_items
    end
    data
  end
  
  def rss_parser2(url)    
    xml = RssItem.extract_xml_item(url)
    puts xml
    data = {
      :title    => xml.xpath('/rss/channel/title').text,
      :home_url => xml.xpath('/rss/channel/link').text,
      :rss_url  => url,
      :items    => []
    }    
    
    xml.xpath('//item').each do |item|
      new_items = {}
      rss_item = RssItem.new
      rss_item.extract(item)
      new_items[:title] = rss_item.title
      # item.elements.each do |e|
        # new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
      # end
      data[:items] << new_items
    end
    data
  end

  def rss_parser2(url)
    require 'rexml/document'
    require 'open-uri'
    xml = REXML::Document.new open(URI.parse(url)).read
    data = {
      :title    => xml.root.elements['channel/title'].text,
      :home_url => xml.root.elements['channel/link'].text,
      :rss_url  => url,
      :items    => []
    }
    xml.elements.each '//item' do |item|
      new_items = {}
      item.elements.each do |e|
        new_items[e.name.gsub(/^dc:(\w)/,"\1").to_sym] = e.text
      end
      data[:items] << new_items
    end
    data
  end
  
  def rss_parser_rss2(url)
    require 'rss/2.0'
    require 'open-uri'
    content = open(url).read
    feed = RSS::Parser.parse(content, false)
    data = {
      :title    => feed.channel.title,
      :home_url => feed.channel.link,
      :rss_url  => url,
      :items    => []
    }
    feed.items.each do |item|
      new_items = {}
      new_items[:title] = item.title
      new_items[:link] = item.link
      new_items[:description] = item.description
      new_items[:pubDate] = item.pubDate
      new_items[:source] = item.source
      new_items[:author] = item.author
      data[:items] << new_items
    end
    data
  end
  

  
  def import_rss_from_url(url)
    require 'open-uri'
    err_titles = []
    begin
      feed = rss_parser(url)
      cdir = ""
      url.scan(/class=(.*?)&/) do |p|
        cdir = p[0]
      end
      if cdir != ""
        catalog = Catalog.find_by_cdir(cdir)
        if !catalog.nil?
          feed[:items].reverse.each do |item|
            title = item[:title].gsub(/\((.*?)\)/, "").gsub(/（(.*?)）/, "")
            litpic = ""
            begin              
              ex_topic = Topic.find_by_title(title)
              if ex_topic.nil?
                desc = item[:description].strip.gsub(/<a(.*?)>/, "").gsub(/<\/a>/, "")
                
                img_src = ""
                desc.scan(/<img(.*?)src="(.*?)"/) do |a, b|
                  img_src = b.to_s
                end
                if img_src != ""
                  desc = desc.gsub(/<img(.*?)>/, "")
                  begin
                    img_src = img_src.gsub("http://t1.baidu.com/it/u=", "").gsub("&fm=30", "")
                    img_src = URI::unescape(img_src)
                    
                    Dir.chdir(Rails.public_path)
                    RailsKindeditor.upload_store_dir.split('/').each do |dir|
                      Dir.mkdir(dir) unless Dir.exist?(dir)
                      Dir.chdir(dir)
                    end
                    @dir = "image"
                    Dir.mkdir(@dir) unless Dir.exist?(@dir)
                                    
                    img_path = "/#{RailsKindeditor.upload_store_dir}/image/#{Time.now.strftime("%Y%m")}/#{Time.now.strftime("%Y%m%d%H%M%S")}"
                    img_path += Digest::MD5.hexdigest(File.dirname(img_src)).slice(0, 12) + "." + img_src.match(/(^|\.)([^\.]+)$/)[2].downcase
  
                    open("#{Rails.public_path}" + img_path, 'wb') do |file|
                      file << open(img_src).read
                    end
                    desc = '<img src="' + img_path + '" />' + desc
                    litpic = img_path
                  rescue
                  else
                  end
                end
                ActiveRecord::Base.transaction do
                  topic = Topic.new
                  topic.catalog = catalog
                  topic.title = title
                  topic.source = item[:source] + "##" + item[:link]
                  topic.writer = item[:author]
                  topic.keywords = title
                  topic.description = desc.gsub(/<(.*?)>/, "")
                  topic.litpic = litpic
                  topic.save!
                  topic_addon = TopicAddon.new
                  topic_addon.topic_id = topic.id
                  topic_addon.content = desc
                  topic_addon.save!
                end
              end    
            rescue
              err_titles << title
              puts title
            else
            end        
          end
        end
      end
    rescue
      feed = "error"
      puts url
    else      
    end    
    [feed, err_titles]
  end
  


