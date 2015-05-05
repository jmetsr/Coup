class User < ActiveRecord::Base

  validates :nickname, uniqueness: true

  after_initialize do |user|
      user.set_session_token
      user.set_time_out_time
  end
  has_many(
    :proposed_games,
    -> { where(active: true) },
    :class_name => "GameProposal",
    foreign_key: :proposer_id
  )
  has_many(
    :games_proposed_to,
    -> { where(active: true) }, 
    :class_name => "GameProposal",
    primary_key: :id,
    foreign_key: :proposed_id
  )

  has_many(
    :people_proposed_to,   
    :through => :proposed_games, 
    :source => :proposed
  )
  has_many(
    :proposers,
    :through => :games_proposed_to,
    :source => :proposer
  )
  has_many(
    :co_proposeds,
    :through => :proposers,
    :source => :people_proposed_to
  )
  belongs_to(
    :game,
    foreign_key: :game_id
  )
  has_many(
    :cards,
    foreign_key: :user_id

  )
  def potential_opponents
    return (self.people_proposed_to + self.proposers + self.co_proposeds + [self]).uniq
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

  def reject
    self.proposed_games.each do |game|
      game.active = false
      game.save
    end
    self.games_proposed_to.each do |game|
      game.active = false
      game.save
    end
    self.rejected = true
    self.accepted = false
    self.save
  end

  def reset
    self.rejected = false
    self.accepted = false
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


