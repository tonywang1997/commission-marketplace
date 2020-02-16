# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'faker'
require 'activerecord-import'



url_file = File.open('seed_url.txt')
url_file_lines = url_file.readlines.map(&:chomp)

user = []
user_c = [:user_name,email_address:,password:,profile_thumbnail:]

portfolio = []
portfolio_c = [artist_id:,description:,price_low:,price_high:,date_created:]

has_images = []
has_images_c = [portfolio_id:,image_id:]

image = []
images_c = [url:]

x = 0

while x < 25 do
    
    user_hash = [:username = Faker::Esport.unique.player, :email = Faker::Internet.unique.email , password: = Faker::Lorem.unique.word, profilethumbnail: = url_file_lines[x]]
    user << user_hash


    portfolio_hash = [artistid: = Faker.unique.number(digits: 5), description: = Faker::ChuckNorris.unique.fact, pricelow: = (x + (2*x) + 1) , pricehi: = (x+(3*x) + 1) , date_created: = Faker::Date.unique]
    portfolio << portfolio_hash

    has_images_hash = [portfolioid: = Faker.unique.number(digits: 5), imageid: = Faker.unique.number(digits: 5)]
    has_images << has_images_hash

    image_hash = [url: = url_file_lines[x]]
    image << image_hash

    x = x + 1
end

User.import user_c, user, validate: false
Artist.import artist_c, artist, validate: false
Portfolio.import portfolio_c, portfolio, validate: false
Has_images.import has_images_c, has_images, validate: false
Images.import images_c, import, validate: false
