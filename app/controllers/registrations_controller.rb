class RegistrationsController < Devise::RegistrationsController
  #after_filter :do_something, only: :create

  respond_to :json

  def create
    super
  end

  def update

    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    
    # Get the form id, so we could clear the fields after remote update
    # Also use to differentiate function to be used during update
    @form_id = params[:user][:form_id]

    @update = nil
    if @form_id == "update-password-form"
      @update = update_resource(@user, account_update_params)
    else    
      @update = @user.update_attributes(account_update_params)
    end

    if @update       
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  protected
    def after_sign_up_path_for(resource)
      #redirect_to user_path(@user.id)
    end
  
end
