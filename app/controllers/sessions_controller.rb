class SessionsController < ApplicationController
  def create
    blogger = Blogger.find_by_person_id(params[:session][:person_id])
    if blogger
      session[:current_user] = blogger  
      redirect_to(people_url)
    else
      render :action => "login"
    end
  end
end