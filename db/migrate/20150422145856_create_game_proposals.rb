class CreateGameProposals < ActiveRecord::Migration
  def change
    create_table :game_proposals do |t|
    	t.integer :proposer_id
    	t.integer :proposed_id
    	t.timestamps
    end
  end
end
