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
OrderItem.destroy_all # 
Song.destroy_all
Album.destroy_all
Artist.destroy_all
Order.destroy_all
User.destroy_all


def generic_order_date(count,initial_date,number_orders)
  increase=count/number_orders
  date_object = Date.parse(initial_date)
  next_date_object = date_object + increase
  next_date_object.to_s  
end



puts "Create Artists"
5.times do
  Artist.create(
    name:Faker::Name.name,
    nationality:Faker::Nation.nationality,
    biography:Faker::Lorem.paragraphs(number: 5).join(""),
    birth_date:Faker::Date.between(from: '1940-01-01', to: '1990-12-31'),
    death_date:Faker::Date.between(from: '1990-01-01', to: '2023-12-31')
  )
end
artist_ids=Artist.ids
# p artist_ids

puts "Create Users"
5.times do
  User.create(
    password: Faker::Internet.password(min_length: 8, max_length: 12, mix_case: true, special_characters: true),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    username:Faker::Name.first_name+Faker::Name.last_name,
    email: Faker::Internet.email(name:Faker::Name.name)   
  )
end
user_ids=User.ids
# p user_ids

puts "Creation of albums with their respective songs "
20.times do
  album=Album.create(
    name: Faker::Music.album,
    price: rand(20..30),
    # duration:0,
    artist_id: artist_ids.sample
  )
  i=rand(5..10)
  i.times do
    song=Song.create(
      name:Faker::Music::RockBand.song,
      duration:rand(120..300),
      album_id:album.id
    )
    album.duration+=song.duration
  end
  album.save
end
album_ids=Album.ids
# p album_ids

puts "Creation of Orders with their respective order details"

initial_date="2022-01-01" # First order date
100.times do |n|
  order=Order.create(
    order_date:generic_order_date(n,initial_date,5), # Create x orders per day
    user_id:user_ids.sample
  )
  i=rand(3..5)
  i.times do
    order_item=OrderItem.create(
      quantity:rand(2..5),
      album_id:album_ids.sample,
      order_id:order.id
    )
    order.total+=order_item.sub_total
  end
  order.save
end







