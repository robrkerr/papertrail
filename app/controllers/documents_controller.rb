class DocumentsController < ApplicationController
	before_filter :find_document, :only => [:show,:update,:destroy]

	def find_document
		@document = Document.find(params[:id])
	end
  
  def show
    respond_to do |format|
      format.json { render :json => @document.full_attributes.to_json }
    end
  end

  def index
  	@document_list = Document.all.map { |doc| doc.full_attributes }
  	respond_to do |format|
      format.json { render :json => @document_list.to_json }
    end
  end

  def create
  	new_document = Document.create!({}) 
  	title_id = Context.where(description: "Title").first.id
  	new_root_point = Point.create({text: "Untitled", 
  																 context_id: title_id, 
  																 document_id: new_document.id,
  																 document_position: 0 })
  	new_document.root_point_id = new_root_point.id
		new_document.save
		respond_to do |format|
      format.json { render :json => new_document.full_attributes.to_json }
    end
  end

  def destroy
  	@document.destroy
  	respond_to do |format|
      format.json { render :json => {}.to_json }
    end
  end

  def update
  end

end
