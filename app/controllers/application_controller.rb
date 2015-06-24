class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in, :login, :logout
  def current_user
    User.find_by_session_token(session[:session_token])
  end
  def logged_in
    !!current_user
  end
  def login(user)
    user.reset_session_token
    session[:session_token] = user.session_token
  end
  def logout
    user = current_user
    user.destroy
  end
  def require_your_turn
    @game = Game.find(params[:id])
    unless @game.current_player == current_user || @game.current_player.is_bot
      fail
    end
  end
  def require_playing_the_game
    @game = Game.find(params[:id])
    unless current_user.game_id == Integer(params[:id])
      fail
    end
  end
  def take_money(amount, player)
    player.money += amount
    player.save
  end
  def take_money_from_another_player(player_one, player_two, amount)
    take_money(amount, player_one)
    take_money(-amount, player_two)
  end

  def preform_action(cost, type, action_type)
    @game = Game.find(params[:id])
    take_money(-cost, @game.current_player)
    @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
    @game.active_player_id = @opponent.id
    @game.record("#{@game.current_player.nickname} #{type} #{@opponent.nickname}.")
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
      message: {action: action_type, opponent: "#{@opponent.nickname}"}.to_json})
    if @opponent.is_bot
      if action_type == "theft"
        redirect_to resolve_theft_url(@game)
      elsif action_type == "coup"
        #kill the bot
        @card_to_remove = @opponent.cards.sample
        @card_to_remove.remove
        @opponent.put_back_card(@card_to_remove)
        if @opponent.cards.length == 0
          @opponent.leave_the_game
     
        switch_turns
        switch_turns if @game.current_player == @opponent

        Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: "turn over"})
      else
        redirect_to(end_turn_url)
      end
      if @game.users.length == 0
        Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: "you win"})
      end  

        #kill the bot
      end
    else
      redirect_to(game_url(@game))
    end
  end

  def switch_turns
    @game = Game.find(params[:id])
    @game.users.each{|player| player.reset_allow}
    if @game.current_player == @game.users.order("id").last
      @game.current_player_id = @game.users.order("id").first.id
    else
      current_player_number = indexx(@game.current_player.id,@game.users.order("id").map{|user| user.id})+1
      if @game.users.order("id")[current_player_number] != nil
        @game.current_player_id = @game.users.order("id")[current_player_number].id
      else
        @game.current_player_id = @game.users.order("id").first.id
      end

    end
    @game.active_player_id = @game.current_player_id
    @game.record("---#{@game.current_player.nickname}'s turn---.")

  end

  def resolve_money_take(money_amount)
    @game = Game.find(params[:id])
    resolve(@game.current_player){take_money(money_amount, @game.current_player)}
  end
  def attempt_to_take(action)
    attempt_to_do(action, "took #{action}")
  end
  def attempt_to_do(action, verb)
    puts "entered the attempt to do method"
    @game = Game.find(params[:id])
    @game.active_player_id = nil
    @game.record("#{@game.current_player.nickname} #{verb}.")
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
      message: {action: "#{action}", opponent: "#{current_user.nickname}"}.to_json})
    if @game.users.select{|user| user != @game.current_player}.all?{ |player| player.is_bot }
      if action == "exchange"
        redirect_to resolve_exchange_url(@game)
      elsif action == "tax"
        redirect_to resolve_tax_url(@game)
      elsif action == "foreign aid"
        redirect_to resolve_foreign_aid_url(@game)
      end
    else
      if !@game.current_player.is_bot
        puts 'current_player is not a bot'
        redirect_to(game_url(@game))
      else
        puts 'current_player is a bot'
        
        Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: "#{action}", opponent: "#{@game.current_player.nickname}"}.to_json})
        sleep(10)
        puts 'we sent the pusher message'
        redirect_to game_url(@game, :action => action)

  
      end
    end
  end
  def resolve(relevant_player, &block)
    @game = Game.find(params[:id])
    current_user.allow
    @opponents = @game.users.select{|player| player != relevant_player}
    if @opponents.all?{|player| player.is_allowing }
      yield if block
      redirect_to(end_turn_url)
    else
      redirect_to(game_url(@game))
    end
  end
  def redirect_to(options = {}, response_status = {})
    ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
    super(options, response_status)
  end
  private
  def indexx(param, array)
    array.each_with_index do |el,index|
      if param <= el
        return index 
      end
    end
    return array.length - 1
  end
end
