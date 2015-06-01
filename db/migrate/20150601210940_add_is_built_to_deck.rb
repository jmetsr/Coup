class AddIsBuiltToDeck < ActiveRecord::Migration
  def change
  	add_column :games, :is_built, :boolean
  end
end
