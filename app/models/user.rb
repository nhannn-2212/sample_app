class User < ApplicationRecord

  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: {maximum: Settings.email_max_length},
    uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :name, presence: true, length: {maximum: Settings.name_max_length}
  validates :password, presence: true, length: {minimum: Settings.pass_min_length}

  # callback macro
  before_save ->{email.downcase!}
  has_secure_password
end
