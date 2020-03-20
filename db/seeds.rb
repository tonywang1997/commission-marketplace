# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'activerecord-import'

User.destroy_all
Tag.destroy_all
Image.destroy_all
Portfolio.destroy_all
HasImage.destroy_all
HasTag.destroy_all
Faker::UniqueGenerator.clear

urls_file_lines = File.open('db/seed_urls.txt').readlines.map(&:chomp)
gallery_urls_file_lines = File.open('db/seed_gallery_urls.txt').readlines.map(&:chomp)
tags_file_lines = File.open('db/seed_tags.txt').readlines.map(&:chomp)

users = []
users_c = [:user_name, :email_address, :password_digest, :profile_thumbnail]

portfolios = []
portfolios_c = [:user_id, :description, :price_low, :price_high , :date_created]

tags = []
tags_c = [:tag_name]

has_tags = []
has_tags_c = [:portfolio_id, :tag_id]

has_images = []
has_images_c = [:portfolio_id, :image_id]

images = []
images_c = [:url, :gallery_url, :price, :date]

puts "Creating users, tags, and images..."
(0...25).to_a.each do |x|
    users << {
        :user_name => Faker::Name.unique.name, 
        :email_address => Faker::Internet.unique.email , 
        :password_digest => User.digest('123456'), 
        :profile_thumbnail => urls_file_lines[x],
    }

    images << {
        :url => urls_file_lines[x], 
        :gallery_url => gallery_urls_file_lines[x],
        :price => rand(100000) / 100.0,
        :date => Time.at(Time.now.to_f * rand).to_date,
    } 

    tags << { :tag_name => tags_file_lines[x] }
end
User.import users_c, users, validate: false
Tag.import tags_c, tags, validate: false
Image.import images_c, images, validate: false
puts "Created users, tags, and images."

puts "Creating portfolios..."
User.all.each do |user|
    num_ports = rand(5)
    num_ports.times do
        portfolios << {
            :user_id => user.id, 
            :description => Faker::ChuckNorris.fact, 
            :price_low => 0,
            :price_high => 0,
            :date_created => Time.at(Time.now.to_f * rand).to_date,
        }
    end
end
Portfolio.import portfolios_c, portfolios, validate: false
puts "Created portfolios."

puts "Creating HasImage and HasTag relationships..."
Portfolio.all.each do |portfolio|
    images = Image.all.sample(rand(10) + 1)
    portfolio.price_low = images.min do |a, b|
        a.price <=> b.price
    end.price
    portfolio.price_high = images.max do |a, b|
        a.price <=> b.price
    end.price
    portfolio.save

    images.each do |image|
        has_images << {
            :portfolio_id => portfolio.id,
            :image_id => image.id,
        }
    end

    tags = Tag.all.sample(rand(10) + 1)
    tags.each do |tag|
        has_tags << {
            :portfolio_id => portfolio.id,
            :tag_id => tag.id,
        }
    end
end
HasImage.import has_images_c, has_images, validate: false
HasTag.import has_tags_c, has_tags, validate: false
puts "Created HasImage and HasTag relationships."

