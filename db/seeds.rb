# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Document.delete_all
Point.delete_all
Subpointlink.delete_all
Context.delete_all
Context.create([{ description: 'Title', position: 0 },
								{ description: 'Background', position: 1 },
								{ description: 'Nomenclature', position: 2 },
								{ description: 'Result', position: 3 },
								{ description: 'Method', position: 4 },
								{ description: 'Discussion', position: 5 },
								{ description: 'Figure', position: 6 },
								{ description: 'Equation', position: 7 },
								{ description: 'Reference', position: 8 },
								{ description: 'Smart Reference', position: 9 },
								{ description: 'Comment', position: 10 }])

## Example document
require "#{Rails.root}/db/document_importer.rb"
importer = DocumentImporter.new
importer.import("#{Rails.root}/data/example_doc.txt")
# load "#{Rails.root}/db/seed_example_document.rb"