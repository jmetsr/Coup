class AddIsBlockingToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_blocking, :boolean
  end
end
