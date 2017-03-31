class UsersController < ApplicationController
	before_filter :set_user, only: [:show]

	skip_before_filter :authenticate_user!

	def index
		if current_user
			@users = User.where.not(id: current_user.id)
		else
			@users = User.all
		end
	end

	def show
	end

	def attending
		@user = User.find(params[:user_id])
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	def attended
		@user = User.find(params[:user_id])
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	def edit_overview
		@user = User.find(params[:user_id])
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	def edit_photo
		@user = User.find(params[:user_id])
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	def edit_account
		@user = User.find(params[:user_id])
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	private
		def set_user
		  @user = User.find(params[:id])
		end

end
