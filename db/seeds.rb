# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# puts "Destroying categories ..."

# Category.destroy_all

# puts "Creating 10 categories..."

# 10.times do
#   Category.create(name: Faker::Job.unique.field)
# end

# puts "Creating 8 users..."

# 8.times do 
#   User.create(email: Faker::Internet.free_email,
#               full_name: Faker::Name.unique.name,
#               about: Faker::Quote.unique.matz,
#               from: Faker::Address.country,
#               language: Faker::Nation.language,
#               image: "https://i.pravatar.cc/300",
#               password: "123456"
#               )
# end

# Create dummy Requests

# 10.times do
#   random_user = User.all.sample
#   category = Category.all.sample
#   request = Request.create(
#       title: Faker::Job.title,
#       description: Faker::Quote.matz,
#       budget: Faker::Number.between(from: 5, to: 50),
#       delivery: Faker::Number.between(from: 1, to: 10),
#       user_id: random_user.id,
#       category_id: category.id
#   )
# end


20.times do
  random_user = User.all.sample
  category = Category.all.sample
  gig = Gig.create(
    title: Faker::Job.unique.title,
    description: Faker::Quote.matz,
    active: Faker::Boolean.boolean,
    user_id: random_user.id,
    category_id: category.id
  )
  number = Faker::Number.between(from: 1, to: 3)
  gig.photos.attach(
    io: File.open("app/assets/images/gig_cover_#{number}.jpg"),
    filename: "category_#{number}.jpeg"
  )    
  gig.pricings.create(
    pricing_type: 0,
    title: Faker::Job.title,
    description: Faker::Quote.matz,
    price: Faker::Number.between(from: 1, to: 9),
    delivery_time: Faker::Number.between(from: 20, to: 30)
  )
  gig.pricings.create(
    pricing_type: 1,
    title: Faker::Job.title,
    description: Faker::Quote.matz,
    price: Faker::Number.between(from: 10, to: 19),
    delivery_time: Faker::Number.between(from: 10, to: 19)
  )
  gig.pricings.create(
    pricing_type: 2,
    title: Faker::Job.title,
    description: Faker::Quote.matz,
    price: Faker::Number.between(from: 20, to: 35),
    delivery_time: Faker::Number.between(from: 1, to: 10)
  )
end