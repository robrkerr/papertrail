
class DocumentImporter

	def import filename
		points_from_file = read_document filename
		title = points_from_file[0]
		document = Document.create!({})
		title_point = create_next_point(document, title, "Title")
		document.root_point_id = title_point.id
		document.save
		previous_points = [title_point]
		points_from_file[1..-1].each { |point_from_file|
			text = point_from_file.split(":")[1..-1].join(":").strip
			context = point_from_file.split(":")[0].strip
			document.reload
			point = create_next_point(document, text, context)
			indentation = point_from_file.split(":")[0].count("\t")
			parent = previous_points[indentation]
			parent.reload
			subpointlink = create_subpointlink(parent, point)
			previous_points[indentation+1] = point
		}
	end

	private

	def read_document filename
		points = []
		file = File.open(filename)
		file.each_line { |line|
			points << line unless line.strip == ""
		}
		file.close
		points
	end

	def create_next_point document, text, context_name
		point = {
			text: text, 
			context_id: get_context_id(context_name), 
			document_id: document.id,
			document_position: document.next_position
		}
		Point.create(point)
	end

	def create_subpointlink parent_point, point
		subpointlink = {
			point_id: parent_point.id,
			subpoint_id: point.id,
			position: parent_point.next_child_position
		}
		Subpointlink.create(subpointlink)
	end

	def get_context_id name
		context = Context.where(description: name).first
		return context.id if context
		Context.where(description: "Result").first.id
	end

end