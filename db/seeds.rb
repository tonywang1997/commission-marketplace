# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'activerecord-import'

Post.destroy_all
PostTag.destroy_all
Role.destroy_all
User.destroy_all
Tag.destroy_all
Image.destroy_all
ActiveStorage::Attachment.all.each do |file|
  file.purge
end
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
image_prices = []
puts "\tCreating metadata and attaching files..."
image_paths.each do |path|
  puts "\t\t#{path}"
  image_info = Img.new(path).to_matrix
  price = rand(50000) / 100.0
  image = Image.new({
    price: price,
    date: Time.at(Time.now.to_f * rand).to_date,
    binary_matrix: MessagePack.pack(Img.sample(image_info[:matrix], 128)),
    r_hist: MessagePack.pack(image_info[:rHist]),
    b_hist: MessagePack.pack(image_info[:bHist]),
    g_hist: MessagePack.pack(image_info[:gHist]),
    color_var: MessagePack.pack(image_info[:colarVar]),
    analyzed: true,
  })
  image.file.attach({
    io: File.open(path),
    filename: File.basename(path),
    content_type: 'image/png',
  })
  if not image.file.attached?
    puts "\t\t\tFailed to attach image #{File.basename(path)}"
  elsif not image.save
    puts "\t\t\tFailed to save image #{File.basename(path)}"
    image.file.purge
  else
    image_prices.push({
      id: image.id,
      price: price,
    })
  end
end
puts "\tCreated metadata and attached files."
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
  images_sample = image_prices.sample(rand(10) + 1)
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

puts "Creating bounty board posts..."
posts = []
posts_c = [:title, :content, :price, :deadline, :user_id]
User.all.each do |u|
  rand(5).times do # 0 to 4 posts per user
    verbs = ['Draw', 'Sketch', 'Paint']
    prof = Faker::Company.profession
    if prof == 'fiherman'
      prof = 'fisherman'
    end
    title = "#{verbs[rand(3)]} #{Faker::JapaneseMedia::DragonBall.character} as #{prof}"
    # todo change content to Action Text
    paragraphs = []
    (rand(3) + 1).times do
      paragraphs.push(Faker::Lorem.paragraph(sentence_count: 20, random_sentences_to_add: 15))
    end
    content = paragraphs.join("\n\n")
    price = rand(50000) / 100.0
    deadline = rand(60).days.from_now.to_date

    posts.push({
      title: title,
      content: content,
      price: price,
      deadline: deadline,
      user_id: u.id,
    })
  end
end
Post.import posts_c, posts, validate: false
puts "Created bounty board posts."

puts "Adding tags and roles to posts..."
posttags = []
posttags_c = [:post_id, :tag_id]
Post.all.each do |p|
  p.tags = Tag.all.sample(rand(8) + 1) # 1 to 8 tags

  roles = []
  (rand(5) + 1).times do # 1 to 5 roles
    roles.push(Role.new({
      category: rand(4),
      name: Faker::Job.position,
      # todo change description to Action Text
      description: Faker::Lorem.paragraph(sentence_count: 5, random_sentences_to_add: 10),
      post_id: p.id,
    }))
    p.roles = roles
  end
end
puts "Added tags and roles to posts."

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
