class Message < ActiveRecord::Base
	# Unread gem
	acts_as_readable :on => :created_at
end
