class DocumentsController < ApplicationController
	before_filter :find_document, :only => [:show,:update,:destroy]

	def find_document
		@document = Document.find(params[:id])
	end
  
  def show
  	
  end

  def index
  	@document_list = Document.all
  	@new_document = Document.new 
  end

  def create
  	new_document = Document.create!({}) 
  	title_id = Context.where(description: "title").first.id
  	new_root_point = Point.create({text: "Untitled", context_id: title_id, document_id: new_document.id })
  	new_document.root_point_id = new_root_point.id
		new_document.save
		redirect_to new_document
  end

  def destroy
  	
  end

  def update
  	
  end

end
