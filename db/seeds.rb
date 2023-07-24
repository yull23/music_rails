# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"

# 10.times do |i|
#   puts Faker::Name.first_name
#   puts Faker::Name.last_name
# end
Artist.destroy_all
Artist.create(name:"Yull")
Artist.create(name:"Yull_2",birth_date:"2023-07-18")
Artist.create(name:"Yull_3",birth_date:"2023-07-18",death_date:"2023-07-18")
Artist.create(name:"Yull_4",death_date:"2023-07-18")
