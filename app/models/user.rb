class User < ApplicationRecord
  before_save { 
    self.email_address.downcase! 
    self.user_name.downcase!
  }
  has_many :portfolios
  validates :user_name, 
    presence: true, 
    length: { maximum: 255 },
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
end
