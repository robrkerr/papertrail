class ContextsController < ApplicationController

	def index
		context_list = Context.where("description != ?", "Title")
		respond_to do |format|
      format.json { render :json => context_list.to_json }
    end
	end
end
