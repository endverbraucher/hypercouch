require 'kramdown'
require 'typogruby'

class Post
  include CouchPotato::Persistence
  include ActiveModel::MassAssignmentSecurity

  attr_accessible :title, :url, :slug, :content, :mdown

  before_save :slugify
  before_save :publish
  before_save :set_url_nil_if_empty

  property :title
  property :url
  property :slug
  property :content
  property :mdown
  property :published_at, :type => Time
  property :published, :type => :boolean, :default => false

  view :published, :key => :published_at, :conditions => 'doc.published'
  view :unpublished, :key => :published_at, :conditions => '!doc.published'

  before_save :convert_mdown
  before_save :set_publish_date
  before_save :slugify
  before_save :set_url_nil_if_empty

  def body
    unless mdown.nil?
      self.content = Kramdown::Document.new(mdown).to_html
      Typogruby.improve self.content
    end
  end

  def improved_title
    Typogruby.improve self.title
  end

  def pub_date
    date = published_at.nil? ? created_at : published_at
    I18n.l date.to_date, format: :long
  end

  def pub_month
    if published
      I18n.l published_at.to_date, format: :only_month
    end
  end

  def pub_year
    if published
      published_at.to_date.year
    end
  end

  def content_feed
    unless url.nil?
      source = '<p>via: <a href="$Source">Source</a></p>'.sub("$Source", url)
      return content + source
    end

    return content
  end

  private

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
end