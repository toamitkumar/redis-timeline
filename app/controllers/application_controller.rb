class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    session[:current_user]
  end
  helper_method :current_user
end
