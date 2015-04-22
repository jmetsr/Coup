class AddActiveToGameProposals < ActiveRecord::Migration
  def change
  	add_column :game_proposals, :active, :boolean
  end
end
