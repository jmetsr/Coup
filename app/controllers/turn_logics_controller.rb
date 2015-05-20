class TurnLogicsController < ApplicationController
	before_filter :require_your_turn, only: [:take_income, :take_foreign_aid, :tax, :steal, :coup, :assassin, :exchange]
	def end_turn
    	@game = Game.find(params[:id])
      @game.users.each{|player| player.reset_allow}
    	if @game.current_player == @game.users.order("created_at").last
      		@game.current_player_id = @game.users.order("created_at").first.id
    	else
     		current_player_number = @game.users.order("created_at").index(@game.current_player)
      		@game.current_player_id = @game.users.order("created_at")[current_player_number+1].id
    	end
    	@game.active_player_id = @game.current_player_id
    	@game.record("---#{@game.current_player.nickname}'s turn---.")
    	Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
         	message: "turn over"})
    	redirect_to(game_url(@game))
  	end
  	def take_income
     	take_money(1, @game.current_player)    
      	@game.record("#{@game.current_player.nickname} took income.")
      	redirect_to(end_turn_url)
  	end
  	def take_foreign_aid
    	@game.record("#{@game.current_player.nickname} took foreign aid.")
     	Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
        	message: {action: "foreign aid", opponent: "#{current_user.nickname}"}.to_json})
      	redirect_to(game_url(@game))
  	end
  	def resolve_foreign_aid
    	@game = Game.find(params[:id])
  		current_user.allow
    	@opponents = @game.users.select{|player| player != @game.current_player}
    	if @opponents.all?{|player| player.is_allowing }
      		take_money(2, @game.current_player)
     	 	redirect_to(end_turn_url)
    	else
      		render :template => "games/show"
    	end
  	end
    def resolve_tax
      @game = Game.find(params[:id])
      current_user.allow
      @opponents = @game.users.select{|player| player != @game.current_player}
      if @opponents.all?{|player| player.is_allowing }
          take_money(3, @game.current_player)
        redirect_to(end_turn_url)
      else
          render :template => "games/show"
      end
    end

  	def tax
      @game.record("#{@game.current_player.nickname} took tax.")
      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "tax", opponent: "#{current_user.nickname}"}.to_json})
      redirect_to(game_url(@game))
  	end
  	def steal
     	preform_action(0, "stole from", "theft")
  	end
  	def resolve_theft
     	  @game = Game.find(params[:id])
      	@opponent = @game.active_player
      	take_money(-2, @opponent)
      	take_money(2, @game.current_player)
      	redirect_to(end_turn_url)
  	end
  	def deal_cards
    	@game = Game.find(params[:id])
    	@game.users.each do |user|
      		2.times do
        		@card = @game.cards.select{|x| x.is_in_deck}.sample
        		@card.deal(user)
      		end
    	end
   	 	Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
         	message: "cards dealt"})
    	render :json => @game
    end
  	def coup
    	preform_action(7,"couped","coup")
    end
  	def assassin
    	preform_action(3,"assassinated","assassin")
  	end
  	def kill
    	@card_to_remove = current_user.cards.select{|x| x.card_type == params['card']}[0]
    	@card_to_remove.remove
    	current_user.cards -= [@card_to_remove]  
    	current_user.save
    	redirect_to(end_turn_url)
  	end
  	def block
		  @game = Game.find(params[:id])
      @game.active_player_id = current_user.id
      @game.save
    	@player = params[:player]
    	if @player == nil
      		@game.record("#{@game.active_player.nickname} blocks with #{params[:card]}.")
    	else
      		@game.record("#{@player} blocks with #{params[:card]}.")
    	end
      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "block", opponent: "#{current_user.nickname}", card: "#{params[:card]}"}.to_json, card: params[:card] })
      #render :template => "games/show"
    	#redirect_to(end_turn_url)
      redirect_to(game_url(@game))
  	end
    def resolve_block
      @game = Game.find(params[:id])
      current_user.allow
      @opponents = @game.users.select{|player| player != @game.active_player}
      if @opponents.all?{|player| player.is_allowing }
        redirect_to(end_turn_url)
      else
        redirect_to(game_url(@game))
      end
    end
  	def challenge
		  @game = Game.find(params[:id])
    	@card = params[:card]
    	@game.record("#{current_user.nickname} challenges.")
      if params[:game_action] != 'block'
        challenged = @game.current_player
      else
        challenged = @game.active_player
      end
    	if challenged.cards.map{|x| x.card_type}.include?(@card)
      		Pusher["game_channel_number_" + @game.id.to_s].trigger('game_data_for_' + @game.id.to_s, {
          		message: {action: "challenge", player: "#{current_user.nickname}", result: "fail"}.to_json})
      		if params[:game_action] == 'theft'
        		take_money(-2, current_user)
        		take_money(2, challenged)
      		end
          if params[:game_action] == 'tax'
            take_money(3, challenged)
          end
          if params[:game_action] == 'block' && @card == 'Duke'
            take_money(2, challenged)
          end
      		@game.record("challenge fails.")
          card_to_reshuffel = challenged.cards.select{|x| x.card_type == @card}[0]
          card_to_reshuffel.is_in_deck = true
          card_to_reshuffel.user_id = nil
          card_to_reshuffel.save
          @card = @game.cards.select{|x| x.is_in_deck}.sample
          @card.deal(challenged)

      		render :template => "games/show"
   		 else
      		Pusher["game_channel_number_" + @game.id.to_s].trigger('game_data_for_' + @game.id.to_s, {
          		message: {action: "challenge", player: "#{challenged.nickname}", result: "succeede"}.to_json})
      		@game.record("challenge succeeds.")

      		#redirect_to(end_turn_url)
          render :template => "games/show"
    	end
 	end
  def exchange
      @game.record("#{@game.current_player.nickname} exchanges.")
      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "exchange", opponent: "#{current_user.nickname}"}.to_json})
        redirect_to(game_url(@game))
  end
  def resolve_exchange
      @game = Game.find(params[:id])
      current_user.allow
      @opponents = @game.users.select{|player| player != @game.current_player}
      if @opponents.all?{|player| player.is_allowing }
        number_of_cards = @game.current_player.cards.length
        @game.current_player.cards.each do |card|
          card.is_in_deck = true
          card.user_id = nil
          card.save
        end
        number_of_cards.times do
          @card = @game.cards.select{|x| x.is_in_deck}.sample
          @card.deal(@game.current_player)
        end
        redirect_to(end_turn_url)
      else
          render :template => "games/show"
      end
  end
end