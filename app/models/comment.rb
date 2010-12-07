class Comment < Base
  property :body
  property :created_at
  property :blogger_id
  property :post_id
  
  def self.create(blogger, post, body)
#    redis.multi do
      comment_id = redis.incr("comment:comments_seq")
      comment = Comment.new(comment_id)
      comment.body = body
      comment.created_at = Time.now.to_s
      comment.blogger_id = blogger.id
      comment.post_id = post.id
      comment.post.add_comment(comment)
      comment.blogger.add_activity(post)
#    end
    comment
  end
  
  def post
    Post.new(post_id)
  end
  
  def blogger
    Blogger.new(blogger_id)
  end
end
