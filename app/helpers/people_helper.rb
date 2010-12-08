module PeopleHelper
  def more_feed?(user, page=1)
    user.posts_count.to_i > (page.to_i * 10)
  end
end
