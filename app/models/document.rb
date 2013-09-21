class Document < ActiveRecord::Base
	has_many :points
	belongs_to :root_point, class_name: "Point"

	def title
		root_point.text
	end

	def main_points
		root_point.subpoints
	end
end
