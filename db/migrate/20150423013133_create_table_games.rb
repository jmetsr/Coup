class CreateTableGames < ActiveRecord::Migration
  def change
    create_table :games do |t|	
    	t.integer :current_player_id

    	t.timestamps
    end
  end
end
