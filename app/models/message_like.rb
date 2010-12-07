class MessageLike < Base
  property :created_at
  property :blogger_id
  property :post_id
  
  def self.create(blogger, post)
#    redis.multi do
      likeable_id = redis.incr("messagelike:comments_seq")
      likeable = MessageLike.new(likeable_id)
      likeable.created_at = Time.now.to_s
      likeable.blogger_id = blogger.id
      likeable.post_id = post.id
      likeable.post.add_activity(likeable)
      likeable.blogger.add_activity(likeable)
#    end
    likeable
  end
  
  def post
    Post.new(post_id)
  end
  
  def blogger
    Blogger.new(blogger_id)
  end
end