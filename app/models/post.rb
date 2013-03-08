require 'kramdown'
require 'typogruby'

class Post
  include CouchPotato::Persistence
  include ActiveModel::MassAssignmentSecurity

  attr_accessible :title, :url, :slug, :content, :mdown

  before_save :slugify
  before_save :set_publish_date
  before_save :set_url_nil_if_empty

  property :title
  property :url
  property :slug
  property :content
  property :mdown
  property :published_at, :type => Time
  property :published, :type => :boolean, :default => false
  property :state

  view :published, :key => :published_at, :conditions => 'doc.published'
  view :in_review, :key => :created_at, :conditions => 'doc.state === "in_review"'
  view :ideas, :key => :created_at, :conditions => 'doc.state === "idea" || !doc.published && doc.state !== "in_review"'
  view :all, :key => :created_at

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

  def publishable?
    start_publishing_time = self.created_at + 3.hours
    if self.state == "in_review" && start_publishing_time <= Time.now
      true
    end
  end

  def content_feed
    unless url.nil?
      source = '<p>via: <a href="$Source">Source</a></p>'.sub("$Source", url)
      return content + source
    end

    return content
  end

  def update_properties
    if self.published
      self.state = "published"
    end

    if self.published_at.nil? && !self.published
      self.state = "idea"
    end

    self.content = nil
  end

  private

    def set_publish_date
      if self.published_at.nil? && self.state == "published"
        self.published_at = Time.now
      end
    end

    def set_url_nil_if_empty
      if url.to_s.empty?
        self.url = nil
      end
    end

    def slugify
      unless self.state == "published"
        self.id = title.parameterize
      end
    end
end