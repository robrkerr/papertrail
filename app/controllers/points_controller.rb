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
			context_id: Context.where(description: 'result').first.id,
			document_id: params[:document_id].to_i 
  	})
  	if params[:parent_id]
  		Subpointlink.create({point_id: params[:parent_id], subpoint_id: new_point.id })
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
  	p params
  	@point.text = params[:text]
  	@point.save
  	respond_to do |format|
      format.json { render :json => @point.full_attributes.to_json }
    end
  end

end
