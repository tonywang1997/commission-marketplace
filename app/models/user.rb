class User < ApplicationRecord
  before_save { 
    self.email_address.downcase! 
    self.user_name.downcase!
  }

  has_many :portfolios
  has_many :posts
  
  # a user has one avatar image
  has_one_attached :avatar

  VALID_USER_NAME_REGEX = /\A[\w+\-]*\Z/i
  validates :user_name, 
    presence: true, 
    length: { maximum: 255 },
    format: { with: VALID_USER_NAME_REGEX },
    uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email_address, 
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true

  has_secure_password
  validates :password,
    presence: true,
    length: { minimum: 6 }


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
