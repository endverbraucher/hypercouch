class PostsController < ApplicationController

  def index
    @posts = CouchPotato.database.view(Post.published(limit: 11, descending: true))["rows"]
    @pub_date = @posts.first["value"].pubdate;

    stale? @posts.first["value"], public: true do
      respond_to do |format|
        format.html # index.html.erb
        format.atom
        format.json { render json: @posts }
      end
    end
  end

  def more
    @posts = CouchPotato.database.view(Post.published(stale: 'ok', limit: 11, descending: true, :startkey => params[:startkey].to_i))["rows"]

    stale? @posts.first["value"], public: true do
      respond_to do |format|
        format.js { render :content_type => 'text/javascript' }
      end
    end
  end

  def show
    @post = CouchPotato.database.load_document(params[:slug])
    @pub_date = @post.pubdate;

    stale? @post, public: true do
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end

  def sitemap
    headers['Content-Type'] = 'application/xml'
    @posts = CouchPotato.database.view(Post.published())["rows"]

    stale? @posts.last["value"], public:true do
      respond_to do |format|
        format.xml { @posts }
      end
    end
  end

end