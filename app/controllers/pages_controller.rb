class PagesController < ApplicationController

	skip_before_filter :authenticate_user!	
	
	def discover
	end	

	def welcome
	end	

	def upcoming
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

	def past
		@ajax = nil

		if request.headers['X-PJAX']
		   @ajax = true
		   render :layout => false
		end
	end

end