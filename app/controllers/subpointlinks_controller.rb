class SubpointlinksController < ApplicationController
	before_filter :find_subpointlinks, :only => [:update,:destroy]

	def find_subpointlinks
		@subpointlink = Subpointlink.find(params[:id])
	end

	def create
		point = Point.find(params[:point_id])
		subpointlink = Subpointlink.create({point_id: point.id, 
																  			subpoint_id: params[:subpoint_id],
												 								position: point.next_child_position})
		respond_to do |format|
      format.json { render :json => subpointlink.to_json }
    end
	end

	def destroy
		@subpointlink.destroy
		respond_to do |format|
      format.json { render :json => {}.to_json }
    end
	end

	def update
		if params[:position]
			@subpointlink.position = params[:position] 
	  	@point.save
	  end
	  respond_to do |format|
      format.json { render :json => @subpointlink.to_json }
    end
	end
end
