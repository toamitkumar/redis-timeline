class MessagesController < ApplicationController
  before_filter :load_blogger, :except => :destroy
  
  def create    
    @post = Post.create(blogger, params[:message][:body])    
  end
  
  def destroy
    post = Post.find_by_id(params[:id])
    post.destroy
    render :nothing => true
  end
  
  def index
    @news_feed = @blogger.timeline(params[:page].to_i)
    render :partial => "index", :locals => {:news_feed => @news_feed}, :layout => nil
  end
  
  protected
  def load_blogger
    @blogger = Blogger.find_by_vendor_individual_id(params[:vendor_individual_id])
  end
end
