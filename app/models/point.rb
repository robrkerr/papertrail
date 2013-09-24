class Point < ActiveRecord::Base
	has_many :subpointlinks, dependent: :destroy, order: "position ASC"
	has_many :parentpointlinks, dependent: :destroy, 
															class_name: "Subpointlink",
															foreign_key: "subpoint_id"
	has_many :subpoints, through: :subpointlinks
	belongs_to :context
	belongs_to :document

	def full_attributes
		subpoints_with_context = subpoints.map { |e| 
			e.attributes.merge({context: e.context.description}) 
		}
		attributes.merge({children: subpoints_with_context, 
			   							context: context.description})
	end

	def next_position
		return 0 if subpointlinks.empty?
		subpointlinks.map { |e| e.position }.max + 1
	end

end
