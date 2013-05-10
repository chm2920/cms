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
  
end
