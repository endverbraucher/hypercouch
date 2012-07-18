xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "http://slog.io"
    xml.priority 1.0
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post["value"])
      xml.lastmod post["value"].updated_at.to_date
      xml.priority 0.9
    end
  end

end