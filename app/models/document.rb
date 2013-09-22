class Document < ActiveRecord::Base
	has_many :points, dependent: :destroy
	belongs_to :root_point, class_name: "Point"

	def title
		root_point.text
	end

	def main_points
		root_point.subpoints
	end

	def full_attributes
		attributes.merge({title: root_point})
	end

end
