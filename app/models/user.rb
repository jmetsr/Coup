class User < ActiveRecord::Base

  validates :nickname, uniqueness: true

  after_initialize do |user|
      user.set_session_token
      user.set_time_out_time
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

  def set_time_out_time
    sign_out_time = Time.now.to_i + 900
    self.time_out_time ||=  sign_out_time
  end  
  def check_time_out
    if Time.now.to_i > self.time_out_time
      self.destroy
      self.save
      Pusher['test_channel'].trigger('my_event', {
          message: "d #{self.id}"
      })
    end
  end

  def self.time_out_users
    User.all.each do |user|
      user.check_time_out
    end
  end


end


