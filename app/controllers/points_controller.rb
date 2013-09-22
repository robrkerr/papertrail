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
  	
  end

  def destroy
  	
  end

  def update
  	@point.text = params[:text]
  	@point.save
  	respond_to do |format|
      format.json { render :json => @point.full_attributes.to_json }
    end
  end

end
