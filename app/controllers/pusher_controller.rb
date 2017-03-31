class PusherController < ApplicationController

  def auth
    if current_user
      response = Pusher.authenticate(params[:channel_name], params[:socket_id], {
        user_id: current_user.id, # => required
        user_info: { # => optional - for example
          name: current_user.first_name,
          email: current_user.email
        }
      })
      render json: response
    else
      render text: 'Forbidden', status: '403'
    end
  end

end