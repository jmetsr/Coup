class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
    	t.integer :game_id
    	t.integer :user_id
    	t.boolean :is_in_deck

    	t.timestamps
    end
    add_index :cards, :game_id
  end
end
