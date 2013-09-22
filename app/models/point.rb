class Point < ActiveRecord::Base
	has_many :subpointlinks
	has_many :subpoints, through: :subpointlinks
	belongs_to :context
	belongs_to :document

	def full_attributes
		attributes.merge({children: subpoints, context: context.description})
	end

end
