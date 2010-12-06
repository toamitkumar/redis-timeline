class Post < Base
  property :content
  property :blogger_id
#  property :attachment
  
  def self.create(blogger, body)
    post_id = redis.incr("post:posts_seq")
    post = Post.new(post_id)
    post.content = {:body => body, :created_at => Time.now.to_s, :updated_at => Time.now.to_s}
    post.blogger_id = blogger.id
    post.blogger.add_post(post)
    redis.lpush("public_timeline", post_id)
    post.blogger.followers.each do |follower|
      follower.add_timeline_post(post)
    end    
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