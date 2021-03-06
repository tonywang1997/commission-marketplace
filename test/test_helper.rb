ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ImageTestHelper
  def seed_test_images(num=10)
    Image.destroy_all
    num.times do
      price = rand(50000) / 100.0
      image = Image.new({
        price: price,
        date: Time.at(Time.now.to_f * rand).to_date,
        binary_matrix: MessagePack.pack(create_matrix),
        binary_hist: MessagePack.pack(create_hist),
        color_var: MessagePack.pack(create_color_var),
        size: rand(1000),
        analyzed: (rand(5) >= 3) ? false : true,
      })
      if not image.save
        puts "ERROR: Failed to save test image: #{image.errors.full_messages}"
      end
    end
  end

  def create_matrix(dim=128)
    matrix = []
    dim.times do
      row = []
      dim.times do
        color = []
        3.times do
          color.push(rand(255))
        end
        row.push(color)
      end
      matrix.push(row)
    end
    matrix
  end

  def create_hist(dim=5)
    hist = []
    dim.times do
      x = []
      dim.times do
        y = []
        dim.times do
          y.push(rand(1000))
        end
        x.push(y)
      end
      hist.push(x)
    end
    hist
  end

  def create_color_var(dim=500)
    color_var = []
    dim.times do
      color_var.push(rand(1000) / 100.0)
    end
    color_var
  end
end

module PortfolioTestHelper
  def seed_test_portfolios(num=10)
    (0...num).each do |port_num|
      user = User.all.sample
      port = Portfolio.new({
        user_id: user.id,
        title: "Portfolio #{port_num} - #{user.user_name}",
      })
      if not port.save
        puts "ERROR: Failed to save test portfolio with errors: #{port.errors.full_messages}"
      end
    end
  end
end

module UserTestHelper
  def seed_test_users(num=10)
    (0...num).each do |user_num|
      user = User.new({
        user_name: "user-#{user_num}",
        email_address: "user-#{user_num}@test.com",
        password: "123456",
      })
      if not user.save
        puts "ERROR: Failed to save test user with errors: #{user.errors.full_messages}"
      end
    end
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ImageTestHelper
  include UserTestHelper
  include PortfolioTestHelper
end

class ActionView::TestCase
  include ImageTestHelper
end
