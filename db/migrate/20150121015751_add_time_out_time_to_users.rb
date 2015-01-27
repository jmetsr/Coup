class AddTimeOutTimeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :time_out_time, :integer
  end
end
