class PeopleController < ApplicationController
  def index
    @news_feed = current_user.posts
    logger.debug @news_feed.inspect
  end  
end
