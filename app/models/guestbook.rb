class Guestbook < ActiveRecord::Base
  attr_accessible :content, :info, :reply, :title
end
