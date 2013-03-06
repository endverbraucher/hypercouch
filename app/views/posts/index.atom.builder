atom_feed do |feed|
  feed.title "slog.io"
  feed.subtitle "Von Beruf Endverbraucher"
  feed.updated @posts.first.published_at

  @posts.each do |post|
    feed.entry post, :published => post.published_at do |entry|
      entry.title post.title
      entry.content post.content_feed, :type =>'html'

      entry.author do |author|
        author.name "slogmen"
      end

      if post.url
        entry.link :href => post.url, :title => post.url, :rel => 'via'
      end
    end
  end
end