class AddIsBotToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_bot, :boolean
  end
end
