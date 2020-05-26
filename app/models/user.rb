class User < ApplicationRecord
  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # attr
  attr_accessor :remember_token, :activation_token

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
  before_create :create_activation_digest
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
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return unless digest

    BCrypt::Password.new(digest).is_password?(token)
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

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
