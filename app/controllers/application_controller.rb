class ApplicationController < ActionController::Base
before_filter :signed_in_user
helper_method :current_user
include SessionsHelper


private

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end

  def signed_in_user
    redirect_to log_in_url, notice: "Please sign in" unless signed_in?
  end


end