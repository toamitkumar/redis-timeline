class Post < Base
  property :content
  property :blogger_id
#  property :attachment
  
  def self.create(blogger, body)
#    redis.multi do 
      post_id = redis.incr("post:posts_seq")
      post = Post.new(post_id)
      post.content = {:body => body, :created_at => Time.now, :updated_at => Time.now}.to_json
      post.blogger_id = blogger.id
      post.blogger.add_post(post)
      redis.lpush("public_timeline", post_id)
      post.blogger.followers.each do |follower|
        follower.add_post_to_timeline(post)
      end
#    end
    post
  end
  
  def self.find_by_id(id)
    if redis.exists("post:id:#{id}:blogger_id")
      Post.new(id)
    end
  end
  
  def destroy
#    redis.multi do 
      blogger.remove_post(self)
      blogger.followers.each do |follower|
        follower.remove_post_from_timeline(post)
      end
      redis.del("post:id:#{id}:content", "post:id:#{id}:blogger_id")
      redis.lrem("public_timeline", 1, id)
#    end
  end
  
  def add_activity(activity)
    set_name = activity.class.name.downcase.pluralize
    redis.lpush("post:id:#{id}:#{set_name}", activity.id)
  end
  
  def comments(page=1)
    from, to = (page-1)*10, page*10
    redis.lrange("post:id:#{id}:comments", from, to).map do |comment_id|
      Comment.new(comment_id)
    end
  end
  
  def likeables(page=1)
    from, to = (page-1)*10, page*10
    redis.lrange("post:id:#{id}:likeables", from, to).map do |likeable_id|
      MessageLike.new(likeable_id)
    end
  end
  
  def blogger
    Blogger.new(blogger_id)
  end
end