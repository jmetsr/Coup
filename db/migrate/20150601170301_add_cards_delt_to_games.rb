class AddCardsDeltToGames < ActiveRecord::Migration
  def change
  	add_column :games, :is_delt, :boolean
  end
end
