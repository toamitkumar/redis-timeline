class MessagesController < ApplicationController
  def create
    blogger = Blogger.find_by_vendor_individual_id(params[:vendor_individual_id])
    @post = Post.create(blogger, params[:message][:body])    
  end
  
  def destroy
    
  end
end
