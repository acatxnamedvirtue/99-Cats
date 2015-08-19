# require 'bcrypt'

class User < ActiveRecord::Base
  attr_reader :password

  # before_validation :ensure_token
  validates :user_name, :password_digest, presence: true
  validates  :user_name, uniqueness: true
  validates :password, length: { minimum: 3, allow_nil: true }

  has_many :cats,
    dependent: :destroy,
    class_name: 'Cat',
    foreign_key: :user_id,
    primary_key: :id

  has_many :requests,
    dependent: :destroy,
    class_name: 'CatRentalRequest',
    foreign_key: :user_id,
    primary_key: :id

  has_many :sessions,
    dependent: :destroy,
    class_name: 'Session',
    foreign_key: :user_id,
    primary_key: :id

  def self.find_by_credentials(credentials)
    user_name = credentials[:user_name]
    password = credentials[:password]

    user = User.find_by(user_name: user_name)

    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  def assign_session_token!(env)
    token = SecureRandom::urlsafe_base64
    Session.create!(session_token: token, user_id: id, browser: env)
    token
  end

  def remove_session_token!(token)
    Session.find_by(session_token: token).destroy!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_digest
    BCrypt::Password.new(super)
  end

  def is_password?(password)
    self.password_digest.is_password?(password)
  end

  private

  # def ensure_token
  #   self.session_token ||= SecureRandom::urlsafe_base64
  # end

end
