class PostsSearchService
  # self === this using JS to classes
  def self.search(curr_post, query)
    curr_post.where("title like '%#{query}%'")
  end
end