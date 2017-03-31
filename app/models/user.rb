class User < ActiveRecord::Base

  # Unread gem (for messages)
  acts_as_reader
  

  ##################### GENERAL USER SETTING ################

  # Return user's full name
  def full_name
  	if !self.first_name.nil? && !self.last_name.nil?
		"#{self.first_name.titleize} #{self.last_name.titleize}"
	elsif !self.oauth_user_name.nil?
		self.oauth_user_name
	else
	end
  end

  # Allow unconfirmed user to sign-in for period of time
  def self.allow_unconfirmed_access_for
    30.days
  end

  # PAPERCLIP SETTING
  #has_attached_file :avatar, styles: { medium: "250x250#", thumb: "35x35#" }
  #validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/


  # DEVISE SETTING
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  # OMNIAUTH SETTING
  def self.from_omniauth(auth, signed_in_resource = nil)

	user = User.where(provider: auth.provider, uid: auth.uid).first

	if user.present?
		user
	else

		# Check wether theres is already a user with the same
		# email address
		user_with_email = User.find_by_email(auth.info.email)

		if user_with_email.present?
			user = user_with_email
		else
		    user = User.new

		    if auth.provider == "facebook"

		    	user.provider = auth.provider
				user.uid = auth.uid
			    user.oauth_token = auth.credentials.token

		    	user.first_name = auth.info.first_name
		    	user.last_name = auth.info.last_name
			    user.email = auth.info.email
			    user.oauth_avatar = auth.info.image

			    # Facebook's token doesn't last forever
				user.oauth_expires_at = Time.at(auth.credentials.expires_at)

				user.skip_confirmation!
				user.save

			elsif auth.provider == "linkedin"

				user.provider = auth.provider
				user.uid = auth.uid
			    user.oauth_token = auth.credentials.token

			    user.first_name = auth.info.first_name
			    user.last_name = auth.info.last_name
			    user.email = auth.info.email

			    #user.oauth_avatar = auth.info.image

			    client = LinkedIn::Client.new
				client.authorize_from_access(auth.extra.access_token.token, auth.extra.access_token.secret)
				user.oauth_avatar = client.picture_urls.all.first

			    user.description = auth.info.description
		    	user.location = auth.info.location

				user.skip_confirmation!
				user.save

			elsif auth.provider == "twitter"

		    	user.provider = auth.provider
				user.uid = auth.uid
			    user.oauth_token = auth.credentials.token

		    	user.oauth_user_name = auth.extra.raw_info.name
		    	user.oauth_avatar = auth.info.image
		    	user.description = auth.info.description
		    	user.location = auth.info.location

	       	elsif auth.provider == "github"

		    	user.provider = auth["provider"]
      			user.uid = auth["uid"]

      			user.oauth_user_name = auth["info"]["name"]
 				user.email = auth["info"]["email"]
 				user.oauth_avatar = auth["info"]["image"]
 				user.location = auth["info"]["location"]
 				user.description = auth["info"]["description"]

 				user.skip_confirmation!
 				user.save

	       	elsif auth.provider == "google_oauth2"

	       		user.provider = auth.provider
				user.uid = auth.uid
			    user.oauth_token = auth.credentials.token

		    	user.first_name = auth.info.first_name
		    	user.last_name = auth.info.last_name
			    user.email = auth.info.email

			    user.oauth_avatar = auth.info.image

			    # Google's token doesn't last forever
				user.oauth_expires_at = Time.at(auth.credentials.expires_at)

				user.skip_confirmation!
				user.save

			else
	       	end


	       	self.after_omniauth(user)

		end
	end

	return user

  end

  # For Twitter (save the session eventhough we redirect user to registration page first)
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  # For Twitter (disable password validation)
  def password_required?
    super && provider.blank?
  end

  # Perform something after user login
  def after_database_authentication

  	# If the identifier is nil, then assign random string
  	# Can be used to identify user if we dont want to use the default id
	identifier = SecureRandom.urlsafe_base64
	if self.identifier.nil?
    	self.update_attribute(:identifier, identifier)
  	end

  	#Send use the first message from admin
  	messages = Message.where('sender_id = ? OR recipient_id = ?', self.id, self.id)
  	if messages.size == 0
 		text = "Hi #{self.id}! Welcome to Witaji!"
 		Message.create({ recipient_id: self.id, sender_id: 1, text: text, pusher_channel: "1-#{self.id}" });
 	end

  end


  # Perform something after user login (omniauth)
  def self.after_omniauth(user)

  	user = User.find(user.id)

  	# If the identifier is nil, then assign random string
  	# Can be used to identify user if we dont want to use the default id
	identifier = SecureRandom.urlsafe_base64
    user.identifier = identifier
    user.save

 	text = "Hi #{user.first_name}, Welcome to Witaji! :)"
 	Message.create({ recipient_id: user.id, sender_id: 1, text: text, pusher_channel: "1-#{user.id}" });

  end

end
