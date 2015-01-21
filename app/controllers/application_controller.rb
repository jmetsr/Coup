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
end
