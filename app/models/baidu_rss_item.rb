#encoding: utf-8
require 'iconv'

class BaiduRssItem
  
  attr_accessor :title, :link, :description, :pub_date, :source, :author, :litpic, :is_new
  
  def self.get(url)
    html = open(URI.parse(url)).read    
    html = Iconv.conv("UTF-8//IGNORE", "GB2312//IGNORE", html)
    html  
  end
  
  def extract(xml_item)    
    xml_item.scan(/<title>(.*?)<\/title>/) do |t|
      self.title = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "").gsub(/\((.*?)\)/, "").gsub(/（(.*?)）/, "")
    end
    xml_item.scan(/<link>(.*?)<\/link>/) do |t|
      self.link = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "")
    end
    xml_item.scan(/<description>(.*?)<\/description>/) do |t|
      self.description = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "").strip.gsub(/<a(.*?)>/, "").gsub(/<\/a>/, "").gsub(/<(.*?)>/, "")
    end
    xml_item.scan(/<pubDate>(.*?)<\/pubDate>/) do |t|
      self.pub_date = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "")
      if self.pub_date.blank?
        self.pub_date = Time.parse(self.pub_date)
      end
    end
    xml_item.scan(/<source>(.*?)<\/source>/) do |t|
      self.source = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "")
    end
    xml_item.scan(/<author>(.*?)<\/author>/) do |t|
      self.author = t[0].to_s.gsub("<![CDATA[", "").gsub("]]>", "")
    end
    
    self.litpic = ""
    xml_item.scan(/<img(.*?)src="(.*?)"/) do |a, b|
      self.litpic = b.to_s
    end
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
