class Game < ActiveRecord::Base
	has_many(
    	:users,
    	:class_name => "User",
   		primary_key: :id,
    	foreign_key: :game_id
 	)
 	belongs_to(
 		:current_player,
 		:class_name => "User",
 		primary_key: :id,
 		foreign_key: :current_player_id
 	)
 	has_many(
 		:cards,
 		:class_name => "Card",
 		primary_key: :id,
 		foreign_key: :game_id
 	)
 	belongs_to(
 		:active_player,
 		:class_name => "User",
 		primary_key: :id,
 		foreign_key: :active_player_id
 	)

 	def record(string)
 		self.log += string
 		self.save
 	end
 	
end