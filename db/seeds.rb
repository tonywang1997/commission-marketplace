# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'activerecord-import'
require 'benchmark'

Benchmark.bm(30) do |bm|
  bm.report("Destroy records in database:") do
    Message.destroy_all
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
    HasPost.destroy_all
    Faker::UniqueGenerator.clear
  end

  bm.report("Create users and tags:") do
    users = []
    users_cols = [:user_name, :email_address, :password_digest, :profile_thumbnail]
    tags = []
    tags_cols = [:tag_name]
    tags_file_lines = File.open('db/seed_tags.txt').readlines.map(&:chomp)
    (0...25).to_a.each do |x|
      users << {
        :user_name => "user#{x}", # Faker::Name.unique.name
        :email_address => "user#{x}@test.com", # Faker::Internet.unique.email 
        :password_digest => User.digest('123456'), 
        :profile_thumbnail => '',
      }

      tags << { :tag_name => tags_file_lines[x] }
    end
    res_users = User.import users_cols, users, validate: false
    puts "ERROR in User import: #{res_users.failed_instances}" if res_users.failed_instances.any?
    res_tags = Tag.import tags_cols, tags, validate: false
    puts "ERROR in Tag import: #{res_tags.failed_instances}" if res_tags.failed_instances.any?
  end

  bm.report("Create images, attach files:") do
    image_paths = Dir.glob('app/assets/images/**/*.png')
    image_paths.each do |path|
      image_info = Img.new(path).to_matrix
      price = rand(50000) / 100.0
      price = 5.0 if File.basename(path) == 'anime_and_manga_15.png'
      image = Image.new({
        price: price,
        date: Time.at(Time.now.to_f * rand).to_date,
        binary_matrix: MessagePack.pack(Cv.dot_matrix(Img.sample(image_info[:matrix], 128))),
        binary_hist: MessagePack.pack(image_info[:hist]),
        color_var: MessagePack.pack(image_info[:colorVar]),
        size: image_info[:size],
        analyzed: true,
      })
      image.file.attach({
        io: File.open(path),
        filename: File.basename(path),
        content_type: 'image/png',
      })
      if not image.file.attached?
        puts "ERROR: Failed to attach image #{File.basename(path)}"
      elsif not image.save
        puts "ERROR: Failed to save image #{File.basename(path)}"
        image.file.purge
      end
    end
  end

  bm.report("Create portfolios:") do
    portfolios = []
    portfolios_cols = [:user_id, :title, :description, :date_created]
    User.all.each do |user|
      num_ports = rand(5)
      (1..num_ports).to_a.each do |port_num|
        portfolios << {
          :user_id => user.id, 
          :title => "#{user.user_name}'s portfolio #{port_num}",
          :description => Faker::ChuckNorris.fact, 
          :date_created => Time.at(Time.now.to_f * rand).to_date,
        }
      end
    end
    res_ports = Portfolio.import portfolios_cols, portfolios, validate: false
    puts "ERROR in Portfolio import: #{res_ports.failed_instances}" if res_ports.failed_instances.any?
  end

  bm.report("Create HasImages, HasTags:") do
    has_images = []
    has_images_cols = [:portfolio_id, :image_id]
    has_tags = []
    has_tags_cols = [:portfolio_id, :tag_id]

    Portfolio.all.each do |portfolio|
      images = Image.all.sample(rand(10) + 1)
      images.each do |image|
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

    res_hasimages = HasImage.import has_images_cols, has_images, validate: false
    puts "ERROR in HasImage import: #{res_hasimages.failed_instances}" if res_hasimages.failed_instances.any?
    res_hastags = HasTag.import has_tags_cols, has_tags, validate: false
    puts "ERROR in HasTag import: #{res_hastags.failed_instances}" if res_hastags.failed_instances.any?
  end

  bm.report("Create bounty board posts:") do
    posts = []
    posts_cols = [:title, :content, :price, :deadline, :user_id]

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
    res_posts = Post.import posts_cols, posts, validate: false
    puts "ERROR in Post import: #{res_posts.failed_instances}" if res_posts.failed_instances.any?
  end

  bm.report("Add tags and roles to posts:") do
    posttags = []
    posttags_cols = [:post_id, :tag_id]
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
  end

  bm.report("Create test user:") do
    u = User.new({
      user_name: 'testuser',
      email_address: 'testuser@test.com',
      password: '123456',
      password_confirmation: '123456',
    })
    puts "ERROR creating test user: ", u.errors.messages unless u.save
  end
end
