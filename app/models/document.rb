class Document < ActiveRecord::Base
	has_many :points, dependent: :destroy, order: "document_position ASC"
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

	def next_position
		return 0 if points.empty?
		points.map { |e| e.document_position }.max + 1
	end

end
