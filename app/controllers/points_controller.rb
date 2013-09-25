class PointsController < ApplicationController
	before_filter :find_point, :only => [:show,:update,:destroy]

	def find_point
		@point = Point.find(params[:id])
	end

	def index
		points = Point.where("document_id = ? AND document_position > 0", params[:document_id]).order("document_position ASC")
		full_points = points.map { |pnt| pnt.full_attributes }
		respond_to do |format|
      format.json { render :json => full_points.to_json }
    end
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
			document_id: params[:document_id],
			document_position: Document.find(params[:document_id]).next_position
  	})
		respond_to do |format|
      format.json { render :json => new_point.full_attributes.to_json }
    end
  end

  def destroy
		position = @point.document_position
		doc_id = @point.document_id
		@point.destroy
		points_to_update = Point.where("document_id = ? AND document_position > ?", doc_id, position)
		points_to_update.each { |pnt| 
			pnt.document_position -= 1
			pnt.save 
		}
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
