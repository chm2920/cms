class Comment < ActiveRecord::Base
  attr_accessible :comment_id, :content, :ip, :uname
  
  belongs_to :topic
  
  has_many :comments
  
end
