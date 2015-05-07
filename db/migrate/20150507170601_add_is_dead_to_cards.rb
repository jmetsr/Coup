class AddIsDeadToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :is_dead, :boolean
  end
end
