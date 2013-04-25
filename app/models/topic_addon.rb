class TopicAddon < ActiveRecord::Base
  
  attr_accessible :content, :topic_id
  
  belongs_to :topic
  
end

