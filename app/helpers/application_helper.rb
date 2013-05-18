#encoding: utf-8
module ApplicationHelper
  
  def format_news_content(content, mixs)
    c = content
    arr = c.split("</p>")
    0.upto arr.length - 1 do |i|
      arr.insert 2 * i, "</p><!--" + mixs[rand(mixs.size)] + "-->"
    end
    c = arr.join("")
    c.html_safe
  end
  
  def catalog_show_path(catalog)
    catalogs = []
    while catalog
      catalogs << catalog
      catalog = catalog.parent_catalog
    end    
    catalogs.reverse!
    
    html = ["<a href=\"/\">首页</a>"]
    url = ''
    catalogs.each do |c|
      url += "/" + c.cdir
      html << ["<a href=\"#{url}\">#{c.name}</a>"]
    end
    html.join('&gt;').html_safe
  end
  
  def topic_previous(topic)
    topic = Topic.find(:first, :conditions => ["id < ? and is_trash = 0 and catalog_id = ?", topic.id, topic.catalog_id], :order => "id desc")
    if !topic.nil?
      topic
    else
      "没有了."
    end
  end
  
  def topic_next(topic)
    topic = Topic.find(:first, :conditions => ["id > ? and is_trash = 0 and catalog_id = ?", topic.id, topic.catalog_id], :order => "id asc")
    if !topic.nil?
      topic
    else
      "没有了."
    end
  end
  
end
