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
Context.create([{ description: 'Title' },
								{ description: 'Background' },
								{ description: 'Result' },
								{ description: 'Method' },
								{ description: 'Nomenclature' },
								{ description: 'Discussion' },
								{ description: 'Figure' },
								{ description: 'Comment' },
								{ description: 'Reference' }])