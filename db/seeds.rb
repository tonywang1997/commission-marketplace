# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'activerecord-import'

url_file = File.open(File.join(Dir.pwd, 'db', 'seed_url.txt'))
url_file_lines = url_file.readlines.map(&:chomp)

user = []
user_c = [:user_name, :email_address, :password_digest, :profile_thumbnail]

portfolio = []
portfolio_c = [:artist_id, :description, :price_low, :price_high , :date_created]

tags = []
tags_c = [:tag_id, :tag_name]

has_tags = []
has_tag_c = [:tag_id, :artist_id]

has_images = []
has_images_c = [:portfolio_id, :image_id]

image = []
images_c = [:url]

x = 0

while x < 25 do
    art_id = Faker::Number.unique.number(digits: 5)
    port_id = Faker::Number.unique.number(digits: 5)
    image_id = Faker::Number.unique.number(digits: 5)
    tag_id = Faker::Number.unique.number(digits:5)

    user_hash = {:user_name => Faker::Name.unique.name, :email_address => Faker::Internet.unique.email , :password_digest => Faker::Lorem.unique.word, :profile_thumbnail => url_file_lines[x]}
    user << user_hash

    portfolio_hash = {:artist_id => art_id.to_i, :description => Faker::ChuckNorris.unique.fact, :price_low => (x + (2*x) + 1).to_f , :price_high => (x+(3*x) + 1).to_f , :date_created => (Faker::Date.unique).to_s}
    portfolio << portfolio_hash

    tags_hash = {:tag_id => tag_id, :tag_name => Faker::Beer.unique.brand}
    tags << tags_hash

    has_tag_hash = {:tag_id => tag_id, :artist_id => art_id}
    has_tags << has_tag_hash

    has_images_hash = {:portfolio_id => port_id, :image_id => image_id}
    has_images << has_images_hash

    image_hash = {:url => url_file_lines[x]}
    image << image_hash

    x = x + 1
    
end

User.import user_c, user, validate: false
Portfolio.import portfolio_c, portfolio, validate: false
Tag.import tags_c, tags, validate: false
HasTag.import has_tag_c, has_tags, validate: false
HasImage.import has_images_c, has_images, validate: false
Image.import images_c, import, validate: false
