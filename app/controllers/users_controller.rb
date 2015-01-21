class UsersController < ApplicationController
	def index
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
      Pusher['test_channel'].trigger('my_event', {
          message: "#{@user.to_json}"
      })
      redirect_to("/#/users")
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to(root_url)
    end
  end


end