class GamesController < ApplicationController

   before_filter :require_your_turn, only: [:take_income, :take_foreign_aid, :tax, :steal, :coup, :assassin]
    
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
    @game.log = "---#{@game.current_player.nickname}'s turn---."
    
    @game.save
    redirect_to :controller => 'cards', :action => 'build_deck', :id => @game.id
  

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
    @game.log += "---#{@game.current_player.nickname}'s turn---."
    @game.save
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: "turn over"
    })

    redirect_to(game_url(@game))
  end
  def take_income

      @game.current_player.money += 1
      @game.log += "#{@game.current_player.nickname} took income."
      @game.save
      @game.current_player.save
      redirect_to(end_turn_url)

  end
  def take_foreign_aid
      
      @game.current_player.money += 2    
      @game.log += "#{@game.current_player.nickname} took foreign aid."
      @game.save
      @game.current_player.save
      redirect_to(end_turn_url)
  end
  def tax
      @game.current_player.money += 3
      @game.log += "#{@game.current_player.nickname} took tax."
      @game.save
      @game.current_player.save
      redirect_to(end_turn_url)
  end
  def steal

      @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
      @opponent.money -= 2
      @opponent.save
      @game.current_player.money += 2
      @game.current_player.save
      @game.log +=  "#{@game.current_player.nickname} stole from #{@opponent.nickname}."
      @game.save
      redirect_to(end_turn_url)
  end
  def deal_cards
    @game = Game.find(params[:id])
    @game.users.each do |user|
      2.times do
        @card = @game.cards.select{|x| x.is_in_deck}.sample
        @card.is_in_deck = false
        @card.user_id = user.id
        @card.save
      end
    end
    render :json => @game
    
  end
  def coup
    @game.current_player.money -= 7
    @game.current_player.save
    @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
    @game.log +=  "#{@game.current_player.nickname} couped #{@opponent.nickname}."
    @game.save
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "coup", opponent: "#{@opponent.nickname}"}.to_json
    })
    # redirect_to(game_url(@game))
    render :show
  end
  def react_to_coup
    @card_to_remove = current_user.cards.select{|x| x.card_type == params['card']}[0]
    current_user.cards -= [@card_to_remove]  
    current_user.save
    redirect_to(end_turn_url)
  end
  def assassin
    @game.current_player.money -= 3
    @game.current_player.save
    @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
    @game.log +=  "#{@game.current_player.nickname} assassinated #{@opponent.nickname}."
    @game.save
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "assassin", opponent: "#{@opponent.nickname}"}.to_json
    })
    redirect_to(game_url(@game))
  end
  def react_to_assassin
    @card_to_remove = current_user.cards.select{|x| x.card_type == params['card']}[0]
    current_user.cards -= [@card_to_remove]  
    current_user.save
    redirect_to(end_turn_url)
  end

end