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
Context.create([{ description: 'title' },
								{ description: 'background' },
								{ description: 'result' },
								{ description: 'method' },
								{ description: 'nomenclature' },
								{ description: 'discussion' },
								{ description: 'figure' },
								{ description: 'reference' }])