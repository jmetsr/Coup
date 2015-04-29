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

    @game = Game.new(number_of_players: params["_json"].to_i)
    @game.current_player_id = current_user.id
    
    @game.save

    render :json => @game

  end
  def show
    @game = Game.find(params[:id])
    render :show
  end
  def end_turn
    @game = Game.find(params[:id])
    
    if @game.current_player == @game.users.order("created_at").last
      @game.current_player_id = @game.users.order("created_at").first.id

    else
      current_player_number = @game.users.order("created_at").index(@game.current_player)
      @game.current_player_id = @game.users.order("created_at")[current_player_number+1].id

    end
    @game.save
    Pusher['game_channel'].trigger('game_data', {
          message: "turn over"
    })
    redirect_to(game_url(@game))
  end
  def take_income
    @game = Game.find(params[:id])
    if @game.current_player == current_user
      @game.current_player.money += 1
      @game.current_player.save
      redirect_to(end_turn_url)
    else
      fail
    end
  end
  def take_foreign_aid
    @game = Game.find(params[:id])
    if @game.current_player == current_user
      @game.current_player.money += 2
      @game.current_player.save
      redirect_to(end_turn_url)
    else
      fail
    end
  end
  def tax
    @game = Game.find(params[:id])
    puts "we see the game"
    if @game.current_player == current_user
      @game.current_player.money += 3
      @game.current_player.save
      redirect_to(end_turn_url)
    else
      fail
    end
  end
  def steal
    @game = Game.find(params[:id])
    if @game.current_player == current_user
      @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
      @opponent.money -= 2
      @opponent.save
      @game.current_player.money += 2
      @game.current_player.save
      redirect_to(end_turn_url)
    else
      fail
    end
  end
end