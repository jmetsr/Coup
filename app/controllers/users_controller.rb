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


end