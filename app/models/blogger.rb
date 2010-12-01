class Blogger < Base
  def self.find_by_username(bloggername)
    if id = redis.get("blogger:bloggername:#{bloggername}")
      Blogger.new(id)
    end
  end
  
  def self.find_by_id(id)
    if redis.key?("blogger:id:#{id}:bloggername")
      Blogger.new(id)
    end
  end
  
  def self.create(bloggername, password)
    user_id = redis.incr("user:uid")
    salt = User.new_salt
    redis.set("user:id:#{user_id}:username", username)
    redis.set("user:username:#{username}", user_id)
    redis.set("user:id:#{user_id}:salt", salt)
    redis.set("user:id:#{user_id}:hashed_password", hash_pw(salt, password))
    redis.push_head("users", user_id)
    User.new(user_id)
  end
  
  def self.new_users
    redis.list_range("users", 0, 10).map do |blogger_id|
      Blogger.new(user_id)
    end
  end
  
  def self.new_salt
    arr = %w(a b c d e f)
    (0..6).to_a.map{ arr[rand(6)] }.join
  end
  
  def self.hash_pw(salt, password)
    Digest::MD5.hexdigest(salt + password)
  end
  
  property :bloggername
  property :salt
  property :hashed_password
  
  def posts(page=1)
    from, to = (page-1)*10, page*10
    redis.list_range("blogger:id:#{id}:posts", from, to).map do |post_id|
      Post.new(post_id)
    end
  end
  
  def timeline(page=1)
    from, to = (page-1)*10, page*10
    redis.list_range("blogger:id:#{id}:timeline", from, to).map do |post_id|
      Post.new(post_id)
    end
  end
  
  def add_post(post)
    redis.push_head("blogger:id:#{id}:posts", post.id)
    redis.push_head("blogger:id:#{id}:timeline", post.id)
  end
  
  def add_timeline_post(post)
    redis.push_head("blogger:id:#{id}:timeline", post.id)
  end
  
  def follow(blogger)
    return if blogger == self
    redis.set_add("blogger:id:#{id}:followees", blogger.id)
    blogger.add_follower(self)
  end
  
  def stop_following(blogger)
    redis.set_delete("blogger:id:#{id}:followees", blogger.id)
    blogger.remove_follower(self)
  end
  
  def following?(blogger)
    redis.set_member?("blogger:id:#{id}:followees", blogger.id)
  end
  
  def followers
    redis.set_members("blogger:id:#{id}:followers").map do |blogger_id|
      Blogger.new(blogger_id)
    end
  end
  
  def followees
    redis.set_members("blogger:id:#{id}:followees").map do |blogger_id|
      Blogger.new(blogger_id)
    end
  end
  
  protected
  
  def add_follower(blogger)
    redis.set_add("blogger:id:#{id}:followers", blogger.id)
  end
  
  def remove_follower(blogger)
    redis.set_delete("blogger:id:#{id}:followers", blogger.id)
  end
end