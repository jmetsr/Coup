class AddIsAlloeingToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_allowing, :boolean
  end
end
