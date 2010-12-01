class Post < Model
  def self.create(blogger, content)
    post_id = redis.incr("post:uid")
    post = Post.new(post_id)
    post.content = content
    post.blogger_id = blogger.id
    post.created_at = Time.now.to_s
    post.blogger.add_post(post)
    redis.push_head("timeline", post_id)
    post.blogger.followers.each do |follower|
      follower.add_timeline_post(post)
    end    
  end
  
  property :content
  property :blogger_id
  property :created_at
  
  def created_at
    Time.parse(_created_at)
  end
  
  def blogger
    Blogger.new(blogger_id)
  end
end