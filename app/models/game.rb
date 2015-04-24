class Game < ActiveRecord::Base
	has_many(
    	:users,
    	:class_name => "User",
   		primary_key: :id,
    	foreign_key: :game_id
 	)
end