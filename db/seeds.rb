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

puts "Creating users and tags..."
(0...25).to_a.each do |x|
    users << {
        :user_name => "user#{x}", # Faker::Name.unique.name
        :email_address => "user#{x}@test.com", # Faker::Internet.unique.email 
        :password_digest => User.digest('123456'), 
        :profile_thumbnail => '',
    }

    tags << { :tag_name => tags_file_lines[x] }
end
User.import users_c, users, validate: false
Tag.import tags_c, tags, validate: false
puts "Created users and tags."

puts "Creating images..."
image_paths = Dir.glob('app/assets/images/**/*.png')
images_c = [:id, :price, :date, :binary_matrix]
images = []
puts "\tCreating metadata..."
image_paths.each_with_index do |path, id|
    puts "\t\t#{path}"
    img = Img.new(path)
    Image.create({
        id: id,
        price: rand(100000) / 100.0,
        date: Time.at(Time.now.to_f * rand).to_date,
        binary_matrix: MessagePack.pack(img.to_matrix)
    })
    # images.push({
    # })
end
puts "\tCreated metadata."

# puts "\tInserting images..."
# Image.import images_c, images, validate: false
# puts "\tInserted images."

puts "\tAttaching image files..."
image_paths.each_with_index do |path, id|
    puts "\t\t#{path}"
    image = Image.find(id)
    image.file.attach({
        io: File.open(path),
        filename: File.basename(path),
        content_type: 'image/png',
    })
    if not image.file.attached?
        puts "Failed to attach image #{File.basename(path)}"
    end
end
puts "\tAttached image files."
puts "Created images."

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
    images_sample = images.sample(rand(10) + 1)
    minmax = images_sample.minmax do |a, b|
        a[:price] <=> b[:price]
    end
    portfolio.price_low = minmax[0][:price]
    portfolio.price_high = minmax[1][:price]
    portfolio.save

    images_sample.each do |image|
        has_images << {
            :portfolio_id => portfolio.id,
            :image_id => image[:id],
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

puts "Creating test user..."
u = User.new({
    user_name: 'testuser',
    email_address: 'testuser@test.com',
    password: '123456',
    password_confirmation: '123456',
})
if u.save
    puts "Created test user."
else
    puts "Error(s) creating test user: ", u.errors.messages
end
