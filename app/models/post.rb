class Post
  include CouchPotato::Persistence
  include ActiveModel::MassAssignmentSecurity
  
  attr_accessible :title, :url, :slug, :content, :mdown
    
  property :title
  property :url
  property :slug
  property :content
  property :mdown
  property :published_at, :type => Time
  property :published, :type => :boolean, :default => false
  
  before_save :convert_mdown
  before_save :set_publish_date
  before_save :slugify
  before_save :set_url_nil_if_empty
  
  view :published, :type => :raw,
        map: "function(doc) {
              if (doc.ruby_class == 'Post' && doc.published)
    	          emit(Date.parse(doc.published_at), doc);
              }"

  view :unpublished, :type => :raw,
        map: "function(doc) {
              if (doc.ruby_class == 'Post' && !doc.published)
    	          emit(Date.parse(doc.created_at), doc);
              }"
              
  def pubdate
    date = published_at.nil? ? created_at : published_at
    date.to_time.strftime("%d. %B %Y, %H:%M Uhr")
  end
  
  def body
    Typogruby.improve content unless content.nil? 
  end
  
  def content_feed
    source = '<p>via: <a href="$Source">Source</a></p>'.sub("$Source", url)
    
    return content if url.nil?      
    return content + source    
  end
  
  private
  
    def convert_mdown
      unless mdown.nil?
        self.content = markdown2html mdown
      end
    end
    
    def set_publish_date
      if published_at.nil? && published
        self.published_at = Time.now
      end
    end
    
    def set_url_nil_if_empty
      if url.to_s.empty?
        self.url = nil
      end
    end
    
    def slugify
      self.id = title.parameterize
    end
    
  	def markdown2html(txt)
  		markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
  			:no_intra_emphasis => true, :autolink => true, :space_after_headers => true, :superscript =>true)
		
  		markdown.render txt
  	end
            
end