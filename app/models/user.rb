class User < ActiveRecord::Base
  validates :nickname, uniqueness: true

  after_initialize do |user|
      user.set_session_token
  end

  def set_session_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
  	return SecureRandom.urlsafe_base64
  end

  def reset_session_token
    self.set_session_token
    self.save
  end

end