require 'spec_helper'

describe Document do
	before do 
		load "#{Rails.root}/db/seeds.rb"
		document_records = Document.create!(documents)
		point_records = Point.create(points)
		document_records.each_with_index { |doc,i| 
			doc.root_point_id = point_records[title_points[i]].id
			doc.save
		}
		Subpointlink.create(subpointlinks)
	end

	context "when the documents have no subpoints" do 
		let(:subpointlinks) { [] }

		context "when no documents have been created" do
			let(:documents) { [] }
			let(:points) { [] }
			let(:title_points) { [] }

			it "has no documents" do Document.count.should == 0 end
			it "has no points" do Point.count.should == 0 end
			it "has no subpointlinks" do Subpointlink.count.should == 0 end
		end

		context "when one documents has been created" do
			let(:documents) { [{}] }
			let(:points) { [{text: "Title 1", 
										 	 context_id: Context.where(description: "title").first.id, 
										   document_id: Document.first.id }] }
			let(:title_points) { [0] }

			it "has one document" do Document.count.should == 1 end
			it "has one point" do Point.count.should == 1 end
			it "has no subpointlinks" do Subpointlink.count.should == 0 end
			it "the document's root point has context 'title'" do 
				Document.first.root_point.context.description.should == "title" 
			end
			it "the document's root point belongs to the document" do 
				Document.first.root_point.document.id.should == Document.first.id 
			end
			it "the document has the correct title" do Document.first.title.should == "Title 1" end
		end
	end
end

