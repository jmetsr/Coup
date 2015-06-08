class AddChatToGames < ActiveRecord::Migration
  def change
  	add_column :games, :chat, :text
  end
end
