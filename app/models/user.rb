class User < ApplicationRecord
  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # attr
  attr_accessor :remember_token

  # validates
  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    uniqueness: {case_sensitive: false},
    format: {with: VALID_EMAIL_REGEX}
  validates :name, presence: true,
    length: {maximum: Settings.name_max_length}
  validates :password, presence: true,
    length: {minimum: Settings.pass_min_length}, allow_nil: true

  # callback macro
  before_save ->{email.downcase!}
  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # forget remember token
  def forget
    update_attribute :remember_digest, nil
  end

  # remember token
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end
end
