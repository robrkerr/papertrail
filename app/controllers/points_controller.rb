class PointsController < ApplicationController
	before_filter :find_point, :only => [:show,:update,:destroy]

	def find_point
		@point = Point.find(params[:id])
	end
  
  def show
    respond_to do |format|
      format.json { render :json => @point.full_attributes.to_json }
    end
  end

  def create
  	new_point = Point.create({
			text: "", 
			context_id: Context.where(description: 'Result').first.id,
			document_id: params[:document_id]
  	})
  	if params[:parent_id]
  		position = Point.find(params[:parent_id]).next_position
  		Subpointlink.create({point_id: params[:parent_id], 
  												 subpoint_id: new_point.id,
  												 position: position })
  	end
		respond_to do |format|
      format.json { render :json => new_point.full_attributes.to_json }
    end
  end

  def destroy
		@point.destroy
  	respond_to do |format|
      format.json { render :json => {}.to_json }
    end  	
  end

  def update
  	@point.context_id = params[:context_id] if params[:context_id]
  	@point.text = params[:text] if params[:text]
  	@point.save
  	respond_to do |format|
      format.json { render :json => @point.full_attributes.to_json }
    end
  end

end
