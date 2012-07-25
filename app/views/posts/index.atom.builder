atom_feed do |feed|
  feed.title "slog.io"
  feed.subtitle "Von Beruf Endverbraucher"
  feed.updated @posts.first["value"].published_at

  @posts.each do |post|
    feed.entry post["value"], :published => post["value"].published_at do |entry|
      entry.title post["value"].title      
      entry.content post["value"].content_feed, :type =>'html'
      
      entry.author do |author|
        author.name "slogmen"
      end
      
      if post["value"].url
        entry.link post["value"].url, :rel => 'via'
      end
    end
  end
end