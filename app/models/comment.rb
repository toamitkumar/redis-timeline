class Comment < Base
  property :content
  property :blogger_id
  property :post_id
  
  def self.create(blogger, post, body)
    comment_id = redis.incr("comment:comments_seq")
    comment = Comment.new(comment_id)
    comment.content = {:body => body, :created_at => Time.now.to_s, :updated_at => Time.now.to_s}
    comment.blogger_id = blogger.id
    comment.post_id = post.id
    comment.post.add_comment(comment)
    comment.blogger.add_activity(post)
  end
  
  def post
    Post.new(post_id)
  end
  
  def blogger
    Blogger.new(blogger_id)
  end
end
