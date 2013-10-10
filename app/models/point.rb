class Point < ActiveRecord::Base
	has_many :subpointlinks, dependent: :destroy, order: "position ASC"
	has_many :parentpointlinks, dependent: :destroy, 
															class_name: "Subpointlink",
															foreign_key: "subpoint_id"
	has_many :subpoints, through: :subpointlinks
	belongs_to :context
	belongs_to :document

	def full_attributes
		full_subpoints = subpointlinks.map { |link| 
			link.subpoint.attributes.merge({
				context: link.subpoint.context.description,
				instances: link.subpoint.num_instances,
				subpointlink_id: link.id,
				subpointlink_position: link.position,
			}) 
		}
		full_parents = parentpointlinks.map { |link| 
			link.point.attributes.merge({
				context: link.point.context.description,
				instances: link.point.num_instances,
				subpointlink_id: link.id,
				subpointlink_position: link.position,
			}) 
		}
		attributes.merge({children: full_subpoints, 
											parents: full_parents, 
			   							context: context.description,
			   							all_possible_children: all_possible_children,
			   							instances: num_instances})
	end

	def next_child_position
		return 0 if subpointlinks.empty?
		subpointlinks.map { |e| e.position }.max + 1
	end

	def all_possible_children
		title_context_id = Context.where(description: "Title").first.id
		possible_children = Point.where("document_id = ? AND id != ? AND context_id != ?",document_id,id,title_context_id)
		possible_children.select { |pnt| !descended_from(pnt) } ## to prevent loops from occuring
	end

	def num_instances
		return 1 if id == document.root_point.id
		parentpointlinks.inject(0) { |sum,link| sum + link.point.num_instances }
	end

	def descended_from point
		parentpointlinks.any? { |link| link.point.id == point.id || link.point.descended_from(point) }
	end

end
