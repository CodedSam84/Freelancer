# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# puts "Destroying categories ..."

# Category.destroy_all

puts "Creating 10 categories..."

10.times do
  Category.create(name: Faker::Job.unique.field)
end

puts "Creating 8 users..."

8.times do 
  User.create(email: Faker::Internet.free_email,
              full_name: Faker::Name.unique.name,
              about: Faker::Quote.unique.matz,
              from: Faker::Address.country,
              language: Faker::Nation.language,
              image: "https://i.pravatar.cc/300",
              password: "123456"
              )
end