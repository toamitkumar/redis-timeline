class PeopleController < ApplicationController
  def index
    @news_feed = current_user.timeline
    @user = current_user
  end  
end
