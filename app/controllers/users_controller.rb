class UsersController < ApplicationController
	def index
    current_user && current_user.reject
    User.time_out_users
    @users = User.all
		render :index
	end

  def user_params
    	params.require(:user).permit(:nickname)
  end

  def create
    flash[:errors] = ""
    @user = User.new(user_params)
    @user.is_blocking = false
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
    @user = User.find(params[:id])
    @user.money = 2;
    game = Game.find_by_current_player_id(params[:accepter_id])
    @user.game_id = game.id
    @user.save
    game.save
    render :json => @user
  end
  def make_into_block
    @user = User.find(params[:id])
    @user.is_blocking = true
    @user.save
    redirect_to(game_url(@user.game_id))
  end
  def show
    @user = User.find(params[:id])
    render :json => @user
  end





end