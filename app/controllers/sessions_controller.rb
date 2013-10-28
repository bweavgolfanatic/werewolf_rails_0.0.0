class SessionsController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new,:create]
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      respond_to do |format|
        format.json { render json: "login successful"}
      end
    else
      respond_to do |format|
        format.json { render json: "login unsuccessful"}
      end
    end
  end


  def destroy
    session[:user_id] = nil
    respond_to do |format|
        format.json { render json: "logged out"}
      end
  end

end