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
		subpointlink_records = subpointlinks.map { |e| 
			{
				point_id: point_records[e[0]].id,
				subpoint_id: point_records[e[1]].id
			}
		}
		Subpointlink.create(subpointlink_records)
	end

	context "when no documents have been created" do
		let(:documents) { [] }
		let(:points) { [] }
		let(:title_points) { [] }
		let(:subpointlinks) { [] }

		it "has no documents" do Document.count.should == 0 end
		it "has no points" do Point.count.should == 0 end
		it "has no subpointlinks" do Subpointlink.count.should == 0 end
	end

	context "when one document has been created" do
		let(:documents) { [{}] }
		let(:points) { [{text: "Title 1", 
									 	 context_id: Context.where(description: "Title").first.id, 
									   document_id: Document.first.id }] }
		let(:title_points) { [0] }
		let(:subpointlinks) { [] }

		it "has one document" do Document.count.should == 1 end
		it "has one point" do Point.count.should == 1 end
		it "has no subpointlinks" do Subpointlink.count.should == 0 end
		it "the document's root point has context 'Title'" do 
			Document.first.root_point.context.description.should == "Title" 
		end
		it "the document's root point belongs to the document" do 
			Document.first.root_point.document.should == Document.first
		end
		it "the document has the correct title" do Document.first.title.should == "Title 1" end

		context "when the document is then deleted" do
			before do
				Document.first.destroy
			end

			it "has no documents" do Document.count.should == 0 end
			it "has no points" do Point.count.should == 0 end
			it "has no subpointlinks" do Subpointlink.count.should == 0 end
		end

		context "when a point is added" do
			let(:points) { [{text: "Title 1", 
									 	 context_id: Context.where(description: "Title").first.id, 
									   document_id: Document.first.id },
									    {text: "Here is a result.", 
									 	   context_id: Context.where(description: "Result").first.id, 
									     document_id: Document.first.id }] }
			let(:subpointlinks) { [[0,1]] }

			it "has no documents" do Document.count.should == 1 end
			it "has no points" do Point.count.should == 2 end
			it "has no subpointlinks" do Subpointlink.count.should == 1 end
			it "there is a point with text 'Here is a result.'" do 
				Point.where(text: "Here is a result.").count.should == 1
			end
			it "this point has context 'Result'" do 
				Point.where(text: "Here is a result.").first.context.description.should == "Result"
			end

			context "when that point is then deleted" do
				before do
					Point.where(text: "Here is a result.").first.destroy
				end

				it "has no documents" do Document.count.should == 1 end
				it "has no points" do Point.count.should == 1 end
				it "has no subpointlinks" do Subpointlink.count.should == 0 end
			end
		end
	end
end

