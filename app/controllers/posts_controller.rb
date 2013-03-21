class PostsController < ApplicationController

  def index
    @posts = CouchPotato.database.view(Post.published(limit: 15, descending: true))

    stale? @posts.first, public: true do
      respond_to do |format|
        format.html # index.html.erb
        format.atom
        format.json { render json: @posts }
      end
    end

  end

  def all
    @posts = CouchPotato.database.view(Post.published(descending: true))

    @archive = Hash[
      @posts.group_by(&:pub_year).map{|year, posts|
        [year, posts.group_by{|post| post.pub_month}]
      }]

      stale? @posts.first, public: true do
        respond_to do |format|
          format.html
        end
      end
    end

    def show
      @post = CouchPotato.database.load_document(params[:slug])

      stale? @post, public: true do
        respond_to do |format|
          format.html
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