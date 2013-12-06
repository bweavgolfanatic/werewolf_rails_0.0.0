class SessionsController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new,:create, :am_i_signed_in]
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      respond_to do |format|
        format.json { render json: "{'message':'login successful'}"}
        format.html { redirect_to users_path}
      end
    else
      respond_to do |format|
        format.json { render json: "{'message':'login unsuccessful'}"}
      end
    end
  end

  def am_i_signed_in
    resp = Hash.new
    if !current_user.nil?
      resp["message"] = "signed in"
    else
      resp["message"] = "not signed in"
    end
    respond_to do |format|
      format.json{render json: resp}
    end
  end


  def destroy
    session[:user_id] = nil
    respond_to do |format|
        format.json { render json: "{'message':'logged out'}"}
        format.html {redirect_to sign_up_path}
      end
  end

end