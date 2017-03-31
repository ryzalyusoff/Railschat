class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?


  protected
  	def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:identifier, :location, :description, :company, :position, :first_name, :last_name, :email, :password, :password_confirmation, :avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [:identifier, :location, :description, :company, :position, :first_name, :last_name, :email, :password, :password_confirmation, :avatar])
  	end
  
end
