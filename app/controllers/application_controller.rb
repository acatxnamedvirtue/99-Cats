class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:token].nil?
    @current_user ||= Session.find_by(session_token: session[:token]).user
  end

  def get_env
    env = request.env["HTTP_USER_AGENT"]
  end

  def sign_in_user!(user)
    session[:token] = user.assign_session_token!(get_env)
  end

  def sign_out_user!
    current_user.remove_session_token!(session[:token]) if current_user
    session[:token] = nil
  end

  private
  def already_signed_in
    redirect_to cats_url if current_user
  end
end
