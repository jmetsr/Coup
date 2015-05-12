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

  def preform_action(cost, type, action_type)
      take_money(-cost, @game.current_player)
      @opponent = @game.users.select{|user| user != current_user && user.nickname == params[:opponent]}[0]
      @game.active_player_id = @opponent.id
      @game.record("#{@game.current_player.nickname} #{type} #{@opponent.nickname}.")
      Pusher["game_channel_number_" + @game.id.to_s ].trigger('game_data_for_' + @game.id.to_s, {
          message: {action: action_type, opponent: "#{@opponent.nickname}"}.to_json})
      redirect_to(game_url(@game))
  end

end
