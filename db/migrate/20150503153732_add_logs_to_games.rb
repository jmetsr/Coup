class AddLogsToGames < ActiveRecord::Migration
  def change
  	add_column :games, :log, :text
  end
end
