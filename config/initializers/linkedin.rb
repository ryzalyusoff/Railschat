LinkedIn.configure do |config| 
	config.token = Rails.application.secrets.linkedin_app_id
	config.secret = Rails.application.secrets.linkedin_app_password
end
