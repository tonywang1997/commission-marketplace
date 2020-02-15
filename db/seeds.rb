# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all

User.new(
  user_name: 'user_1',
  email_address: 'user_1@example.com',
  password: 'password_1',
  password_confirmation: 'password_1',
  profile_thumbnail: 'some_profile_pic'
).save