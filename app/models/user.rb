class User < ApplicationRecord
  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # attr macro

  # relation macro

  # validation macro

  validates :email, presence: true, length: {maximum: 55},
    uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :name, presence: true, length: {maximum: 50}
  validates :password, presence: true, length: {minimum: 6}
  # callback macro

  before_save ->{email.downcase!}

  # scopes

  has_secure_password
end
