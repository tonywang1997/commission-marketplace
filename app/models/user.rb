class User < ApplicationRecord
  before_save { 
    self.email_address.downcase! 
    self.user_name.downcase!
  }

  has_many :portfolios
  has_many :favorite_posts
  has_many :posts, through: :favorite_posts
  
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

  validates :password,
    presence: true,
    length: { minimum: 6 },
    if: :password_validation_required?

  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def password_validation_required?
    self.password_digest.blank? or !(self.password.nil? or self.password.empty?)
  end
end
