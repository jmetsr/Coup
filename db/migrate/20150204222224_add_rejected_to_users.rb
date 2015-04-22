class AddRejectedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :rejected, :boolean
  end
end
