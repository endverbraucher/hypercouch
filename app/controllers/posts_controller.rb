class PostsController < ApplicationController

  def index
    @posts = CouchPotato.database.view(Post.published(limit: 15, descending: true))
    @pub_date = [@posts.first.published_at.to_datetime.rfc3339, @posts.first.pub_date];

    stale? @posts.first, public: true do
      respond_to do |format|
        format.html # index.html.erb
        format.atom
        format.json { render json: @posts }
      end
    end

  end

  def all
    posts = CouchPotato.database.view(Post.published(descending: true))

    @archive = Hash[
      posts.group_by(&:pub_year).map{|year, posts|
        [year, posts.group_by{|post| post.pub_month}]
    }]

    @pub_date = [posts.first.published_at.to_datetime.rfc3339,
      posts.first.pub_date];

      stale? posts.first, public: true do
        respond_to do |format|
          format.html # show.html.erb
        end
      end
    end

    def show
      @post = CouchPotato.database.load_document(params[:slug])
      @pub_date = [@post.published_at.to_datetime.rfc3339, @post.pub_date];

      stale? @post, public: true do
        respond_to do |format|
          format.html # show.html.erb
        end
      end
    end

    def sitemap
      headers['Content-Type'] = 'application/xml'
      @posts = CouchPotato.database.view(Post.published())

      stale? @post, public: true do
        respond_to do |format|
          format.xml { @posts }
        end
      end
    end

  end