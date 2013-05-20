#encoding: utf-8
require 'nokogiri'
require 'open-uri'

class RssItem
  
  attr_accessor :catalog, :title, :source, :author, :keywords, :description, :litpic, :content, :pub_date, :link, :is_new
  
  def self.extract_xml_item(url)
    Nokogiri::XML open(URI.parse(url)).read    
  end
  
  def extract(xml_item)
    self.title = xml_item.css('title').text.gsub(/\((.*?)\)/, "").gsub(/（(.*?)）/, "")
    self.description = xml_item.css('description').text.strip.gsub(/<a(.*?)>/, "").gsub(/<\/a>/, "").gsub(/<(.*?)>/, "")
    if !xml_item.css('pubDate').text.blank?
      self.pub_date = Time.parse(xml_item.css('pubDate').text)
    end
    self.source = xml_item.css('source').text
    self.link = xml_item.css('link').text
    self.author = xml_item.css('author').text
    self.litpic = ""
    
    img_src = ""
    self.description.scan(/<img(.*?)src="(.*?)"/) do |a, b|
      img_src = b.to_s
    end
    if img_src != ""
      self.litpic = img_src
    end
  end
  
  def h(dom)
    Nokogiri::HTML(dom.inner_text.strip).inner_text.strip
  end
  
  def save(catalog)
    ActiveRecord::Base.transaction do
      topic = Topic.new
      topic.catalog = catalog
      topic.title = self.title
      topic.source = self.source + "##" + self.link
      topic.writer = self.author
      topic.keywords = self.title
      topic.description = self.description
      topic.litpic = self.litpic
      topic.save!
      topic_addon = TopicAddon.new
      topic_addon.topic_id = topic.id
      topic_addon.content = self.description
      topic_addon.save!
    end
  end
  
end



    # self.title = h(xml_item.css('title'))
    # self.description = h(xml_item.css('description'))
    # self.pub_date = Time.parse(h(xml_item.css('pubDate')))