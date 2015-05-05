class Card < ActiveRecord::Base
	belongs_to(
		:game,
		:class_name => "Game",
      	primary_key: :id,
      	foreign_key: :game_id
	)
	belongs_to(
		:user,
		:class_name => "User",
      	primary_key: :id,
      	foreign_key: :user_id
	)
end