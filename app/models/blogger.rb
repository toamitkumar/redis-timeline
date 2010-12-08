class Blogger < Base
  property :name
  property :person_id
  property :vendor_individual_id
  
  def self.initialize_all(bloggers=[])
    bloggers.each do |b|
      blogger_id = redis.incr("blogger:blogers_seq")
      redis.set("blogger:id:#{blogger_id}:name", b[:name])
      redis.set("blogger:id:#{blogger_id}:person_id", b[:person_id])
      redis.set("blogger:id:#{blogger_id}:vendor_individual_id", b[:vendor_individual_id])
      redis.set("blogger:name:#{b[:name]}", blogger_id)
      redis.set("blogger:person_id:#{b[:person_id]}", blogger_id)
      redis.set("blogger:vendor_individual_id:#{b[:vendor_individual_id]}", blogger_id)      
      redis.lpush("bloggers", blogger_id)
    end
  end
  
  def self.all_bloggers
    redis.lrange("bloggers", 0, 10).collect do |blogger_id|
      Blogger.new(blogger_id)
    end
  end
  
  def self.find_by_name(bloggername)
    if id = redis.get("blogger:name:#{bloggername}")
      Blogger.new(id)
    end
  end
  
  def self.find_by_id(id)
    if redis.exists("blogger:id:#{id}:name")
      Blogger.new(id)
    end
  end
  
  def self.find_by_person_id(person_id)
    if(id=redis.get("blogger:person_id:#{person_id}"))
      Blogger.new(id)
    end
  end
  
  def self.find_by_vendor_individual_id(vendor_individual_id)
    if(id=redis.get("blogger:vendor_individual_id:#{vendor_individual_id}"))
      Blogger.new(id)
    end
  end
  
  def posts(page=1)
    from, to = (page-1)*10, page*9
    redis.lrange("blogger:id:#{id}:posts", from, to).map do |post_id|
      Post.new(post_id)
    end
  end
  
  def posts_count
    redis.llen("blogger:id:#{id}:posts")
  end
  
  def timeline(page=1)
    from, to = (page-1)*10, page*9
    redis.lrange("blogger:id:#{id}:timeline", from, to).map do |post_id|
      Post.new(post_id)
    end
  end
  
  def add_post(post)
#    redis.multi do 
      redis.lpush("blogger:id:#{id}:posts", post.id)
      add_post_to_timeline(post)
#    end
  end
  
  def remove_post(post)
#    redis.multi do
      redis.lrem("blogger:id:#{id}:posts", 1, post.id)
      remove_post_from_timeline(post)
#    end
  end
  
  def add_post_to_timeline(post)
    redis.lpush("blogger:id:#{id}:timeline", post.id)
  end
  
  def remove_post_from_timeline(post)
    redis.lrem("blogger:id:#{id}:timeline", 1, post.id)
  end
  
  def add_activity(activity)
    if(redis.sismember("blogger:id:#{id}:posts", activity.id))
      redis.srem("blogger:id:#{id}:posts", activity.id)
    end
    add_post(activity)
  end
  
  def follow(blogger)
    return if blogger == self
    redis.sadd("blogger:id:#{id}:followees", blogger.id)
    blogger.add_follower(self)
  end
  
  def stop_following(blogger)
    redis.srem("blogger:id:#{id}:followees", blogger.id)
    blogger.remove_follower(self)
  end
  
  def following?(blogger)
    redis.sismember("blogger:id:#{id}:followees", blogger.id)
  end
  
  def followers
    redis.smembers("blogger:id:#{id}:followers").map do |blogger_id|
      Blogger.new(blogger_id)
    end
  end
  
  def followees
    redis.smembers("blogger:id:#{id}:followees").map do |blogger_id|
      Blogger.new(blogger_id)
    end
  end
  
  protected
  
  def add_follower(blogger)
    redis.sadd("blogger:id:#{id}:followers", blogger.id)
  end
  
  def remove_follower(blogger)
    redis.srem("blogger:id:#{id}:followers", blogger.id)
  end
end