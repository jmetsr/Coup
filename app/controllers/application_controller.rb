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
    unless @game.current_player == current_user
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
    take_money(-cost, @game.current_player)
    @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
    @game.active_player_id = @opponent.id
    @game.record("#{@game.current_player.nickname} #{type} #{@opponent.nickname}.")
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
      message: {action: action_type, opponent: "#{@opponent.nickname}"}.to_json})
    redirect_to(game_url(@game))
  end

  def switch_turns
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
  end

  def resolve_money_take(money_amount)
    @game = Game.find(params[:id])
    resolve(@game.current_player){take_money(money_amount, @game.current_player)}
  end
  def attempt_to_take(action)
    attempt_to_do(action, "took #{action}")
  end
  def attempt_to_do(action, verb)
    @game.active_player_id = nil
    @game.record("#{@game.current_player.nickname} #{verb}.")
    Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
      message: {action: "#{action}", opponent: "#{current_user.nickname}"}.to_json})
    redirect_to(game_url(@game))
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
end
