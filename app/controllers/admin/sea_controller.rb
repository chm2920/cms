#encoding: utf-8
class Admin::SeaController < Admin::Backend
  
  def rss
    if !params[:url].nil?
      begin
        @feed = rss_parser(params[:url])
      rescue
        @feed = "error"
      else
        
      end
    end
  end
  
  def import_rss
    feed = import_rss_from_url(params[:url])
    if feed == "error"
      render :text => "error"
    else
      redirect_to [:admin, :topics]
    end
  end

  def auto
    case request.method
    when "POST"
    else
      @catalogs = Catalog.all(:conditions => "parent_id = 0", :order => "sortrank asc, id asc")
    end    
  end
  
private

  def rss_parser(url)
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
  
  def import_rss_from_url(url)
    require 'open-uri'
    
    begin
      feed = rss_parser(url)
      cdir = ""
      params[:url].scan(/class=(.*?)&/) do |p|
        cdir = p[0]
      end
      if cdir != ""
        catalog = Catalog.find_by_cdir(cdir)
        if !catalog.nil?
          feed[:items].reverse.each do |item|
            title = item[:title].gsub(/\((.*?)\)/, "").gsub(/（(.*?)）/, "")
            litpic = ""
            
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
          end
        end
      end
    rescue
      feed = "error"
      puts url
    else      
    end    
    feed
  end
  
end