class GamesController < ApplicationController

	def propose

	  Pusher['test_channel'].trigger('my_event', {
          message: params.to_json
    })
    proposer = User.find(params["proposerId"])
    proposed = User.find(params["playerIds"])

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

    all_accepted = current_user.potential_opponents.all? {|user| user.accepted}
    numb_players = current_user.potential_opponents.length
		Pusher['test_channel'].trigger('my_event', {
          message: "accepts #{current_user.id}, number_of_opponents = #{numb_players}, everyone accepted: #{all_accepted}"
    })
   
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
  def create
    puts "enter the create action for game"
    @game = Game.new(number_of_players: params["_json"].to_i)
    @game.current_player_id = current_user.id
    
    @game.save

    render :json => @game
    puts "left the create action for game"
  end
  def show
    @game = Game.find(params[:id])
    render :show
  end
  def end_turn
    @game = Game.find(params[:id])
    if @game.current_player = @game.users.last
      @game.current_player_id = @game.users.first.id

    else
      current_player_number = @game.users.index(@game.current_player)
      @game.current_player_id = @game.users[current_player_number+1].id
    end
    @game.save
    puts "It now should be #{@game.current_player.nickname}'s turn"
    Pusher['game_channel'].trigger('game_data', {
          message: "turn over"
    })
    redirect_to(game_url(@game))
  end
  def take_income
    @game = Game.find(params[:id])
    if @game.current_player = current_user
      @game.current_player.money += 1
      @game.current_player.save
      redirect_to(end_turn_url)
    end
  end
end