class SessionsController < ApplicationController
  before_action :already_signed_in
  skip_before_action :already_signed_in, only: [:destroy, :signins]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(user_params)


    if @user.nil?
      @user = User.new
      render :new
    else
      sign_in_user!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    sign_out_user!
    redirect_to cats_url
  end

  def signins
    @signouts = current_user.sessions.where("session_token != ?", session[:token])
  end

  def other_signout
    current_user.remove_session_token!(token)
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
