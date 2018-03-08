class SessionsController < ApplicationController
  before_action :login_guard
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user
      session[:session_token] = user.session_token
      flash.now[:success] = "Success! you logged in!"
      redirect_to cats_url
    else
      flash.now[:errors] = ["Login not authorized"]
      render :new
    end
  end

  def destroy
    if logged_in?
      current_user.session_token = current_user.reset_session_token!
      current_user.save!
      session[:session_token] = nil
      redirect_to new_session_url
    end
  end

private

  def login_guard
    if logged_in?
      redirect_to cats_url
    end
  end

end
