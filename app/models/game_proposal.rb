class GameProposal < ActiveRecord::Base

	belongs_to(
      :proposer,
      :class_name => "User",
      primary_key: :id,
      foreign_key: :proposer_id
  	)
  	belongs_to(
      :proposed,
      :class_name => "User",
      primary_key: :id,
      foreign_key: :proposed_id
  	)
end