class User < ApplicationRecord
  # constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  # attr macro
  attr_accessor :remember_token, :activation_token, :reset_token

  # relation macro
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships

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
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
     reset_sent_at: Time.zone.now
  end

  def send_pwd_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # kiem tra link reset password co het han hay chua?
  def password_reset_expired?
    reset_sent_at < Settings.time_link_expire.hours.ago
  end

  def feed
    Micropost.get_feed(following_ids, id).sort_by_created_at
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
