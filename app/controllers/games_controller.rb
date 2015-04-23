class GamesController < ApplicationController

	def propose

	  Pusher['test_channel'].trigger('my_event', {
          message: params.to_json
    })
    proposer = User.find(params["proposerId"])
    proposed = User.find(params["playerIds"])
    puts params

    proposed.each do |proposed|
      proposal = GameProposal.new
      proposal.proposer = proposer 
      proposal.proposed = proposed
      proposal.active = true
      proposal.save
    end

      render :json => params
	end

	def accept
    @user = current_user
    @user.update_attributes(:accepted => true)
    @user.save

		Pusher['test_channel'].trigger('my_event', {
          message: "accepts #{current_user.id}"
    })

    puts (current_user.potential_opponents - [current_user]).all? {|user| user.accepted }
    current_user.potential_opponents.each do |user|
      puts "#{user.nickname} #{user.accepted}"
    end

    render :json => params
	end

	def reject
		current_user.reject
		Pusher['test_channel'].trigger('my_event', {
          message: "rejects #{current_user.id}"
    	})
    
    current_user.proposed_games.each do |proposal|
      proposal.active = false #since the propsal was rejected we label it inactive
      proposal.save
    end
    render :json => params
	end


end