class User < ApplicationRecord

  validates :username, uniqueness: true, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    if user && user.is_password?(password)
      return user
    else
      return nil
    end
  end

  def ensure_session_token
    self.session_token ||= reset_session_token!
  end

  def reset_session_token!
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

end
