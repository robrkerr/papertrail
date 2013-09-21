class Subpointlink < ActiveRecord::Base
	belongs_to :point
	belongs_to :subpoint, class_name: "Point"
end
