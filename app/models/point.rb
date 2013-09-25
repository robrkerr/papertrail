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
				subpointlink_id: link.id,
				subpointlink_position: link.position,
			}) 
		}
		attributes.merge({children: full_subpoints, 
			   							context: context.description,
			   							all_possible_children: all_possible_children,
			   							num_instances: num_instances})
	end

	def next_child_position
		return 0 if subpointlinks.empty?
		subpointlinks.map { |e| e.position }.max + 1
	end

	def all_possible_children
		### Definitely these criteria
		# - only points with the same document
		# - not this point
		# - not the title point
		title_context_id = Context.where(description: "Title").first.id
		Point.where("document_id = ? AND id != ? AND context_id != ?",document_id,id,title_context_id)
		### Maybe these criteria
		# - not points that are already children?
		# - not points that are parents/grandparents/etc of this point?
	end

	def num_instances
		parentpointlinks.count
	end

end
