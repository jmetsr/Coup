class TurnLogicsController < ApplicationController
	before_filter :require_your_turn, only: [:take_income, :take_foreign_aid, :tax, :steal, :coup, :assassin, :exchange]
  before_filter :require_playing_the_game, except: [:deal_cards]
  def take_income
    take_money(1, @game.current_player)    
    @game.record("#{@game.current_player.nickname} took income.")
    redirect_to(end_turn_url)
  end
  def take_foreign_aid() attempt_to_take("foreign aid") end
  def resolve_foreign_aid() resolve_money_take(2) end
  def tax() attempt_to_take("tax") end
  def resolve_tax() resolve_money_take(3) end
  def steal() preform_action(0, "stole from", "theft") end
  def coup() preform_action(7,"couped","coup") end
  def assassin() preform_action(3,"assassinated","assassin") end
  def exchange() attempt_to_do("exchange","exchanges") end
  def resolve_block() resolve(Game.find(params[:id]).active_player) end
  def resolve_theft
    @game = Game.find(params[:id])
    @opponent = @game.active_player
    take_money_from_another_player(@game.current_player, @opponent, 2)
    redirect_to(end_turn_url)
  end
  def deal_cards
    puts "we are in the deal cards method"
    @game = Game.find(params[:id])
    @game.is_delt = true 
    @game.save
    # Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
    #   message: "cards dealt"})
    render :json => @game
  end
  def kill
    @card_to_remove = current_user.cards.select{|x| x.card_type == params['card']}[0]
    @card_to_remove.remove
    current_user.put_back_card(@card_to_remove)
    if current_user.cards.length == 0
      current_user.leave_the_game
      render :template => "static_pages/you_lose"
      switch_turns
      switch_turns if @game.current_player == current_user

      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
        message: "turn over"})
    else
    	redirect_to(end_turn_url)
    end
    if @game.users.length == 0
      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
        message: "you win"})
    end
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
    redirect_to(game_url(@game))
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
        take_money_from_another_player(challenged, current_user, 2)
      end
      take_money(3, challenged) if params[:game_action] == 'tax'
      take_money(2, challenged) if params[:game_action] == 'block' && @card == 'Duke'
      @game.record("challenge fails.")
      card_to_reshuffle = challenged.cards.select{|x| x.card_type == @card}[0]
      card_to_reshuffle.reshuffle
      @card = @game.cards.select{|x| x.is_in_deck}.sample
      @card.deal(challenged)
      render :template => "games/show"
   	else
      Pusher["game_channel_number_" + @game.id.to_s].trigger('game_data_for_' + @game.id.to_s, {
        message: {action: "challenge", player: "#{challenged.nickname}", result: "succeede"}.to_json})
      @game.record("challenge succeeds.")
      render :template => "games/show"
    end
 	end
  def resolve_exchange
    @game = Game.find(params[:id])
    resolve(@game.current_player) do
      number_of_cards = @game.current_player.cards.length
      @game.current_player.cards.each do |card|
        card.reshuffle
      end
      number_of_cards.times do
        @card = @game.cards.select{|x| x.is_in_deck}.sample
        @card.deal(@game.current_player)
      end
    end
  end
  def end_turn
    switch_turns
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
      message: "turn over"})
    redirect_to(game_url(@game))
  end
end