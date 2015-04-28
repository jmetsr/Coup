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
 	
end