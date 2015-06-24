class UsersController < ApplicationController
	def index
    User.time_out_users
    current_user && current_user.reject
    @users = User.all
		render :index
    bots = User.all.select{|user| user.is_bot }
    if bots.length == 0
      @user = User.new(nickname: "Bot 1")
      @user.is_blocking = false
      @user.is_allowing = true
      @user.accepted = true
      @user.is_bot = true
      @user.save
      @user2 = User.new(nickname: "Bot 2")
      @user2.is_blocking = false
      @user2.is_allowing = true
      @user2.accepted = true
      @user2.is_bot = true
      @user2.save

    else
      puts "there are alredy bots"
      last_bot_so_far = bots.sort_by{|user| user.created_at}.last
      name = last_bot_so_far.nickname 
      # create a new bot with a new name
      new_name = "Bot " + String(Integer(name[4..-1])+1)
      @user = User.new(nickname: new_name)
      @user.is_blocking = false
      @user.is_allowing = true
      @user.accepted = true
      @user.is_bot = true
      puts "about to save a bot"
      @user.save
      @user2 = User.new(nickname: "Bot " + String(Integer(new_name[4..-1])+1))
      @user2.is_blocking = false
      @user2.is_allowing = true
      @user2.accepted = true
      @user2.is_bot = true
      puts "about to save another bot"
      @user2.save
    end

	end

  def user_params
    	params.require(:user).permit(:nickname)
  end

  def create
    flash[:errors] = ""
    @user = User.new(user_params)
    @user.is_blocking = false
    @user.is_allowing = false
    @user.is_bot = false
    if @user.save
      login(@user)
      Pusher['test_channel'].trigger('my_event', {
          message: "#{@user.to_json}"
      })
      redirect_to("/#/users")
    else
      flash[:errors] = @user.errors.full_messages[0]
      redirect_to(root_url)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render :json => "you have been logged out due to inactivity"
  end

  def update

    puts 'entered users update action'
    @user = User.find(params[:id])
    puts 'identified user'
    @user.money = 2;
    puts 'game him money'
    game = Game.find_by_current_player_id(params[:accepter_id])
    puts 'ser the game'
    if game.is_built
      puts 'game was built'
      @user.game_id = game.id
      @user.save
      game.save
      puts "#{@user} joined the game"
      if @user.cards.length == 0
        2.times do
          @card = game.cards.select{|x| x.is_in_deck}.sample
          @card.deal(@user)
        end
      end
      render :show
    else
      puts "game wasn't built"
      fail
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

end