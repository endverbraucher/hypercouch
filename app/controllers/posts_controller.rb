class PostsController < ApplicationController

  def index
    @posts = CouchPotato.database.view(
      Post.published(limit: 11, descending: true))["rows"]
    @pub_date = @posts.first["value"].pubdate;
    @more_posts = CouchPotato.database.view(
      Post.archive(stale: 'ok', limit: 11, descending: true,
      :startkey => @posts.last["key"] ))["rows"]

    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.json { render json: @posts }
    end

  end

  def more
    @posts = CouchPotato.database.view(
    Post.published(stale: 'ok', limit: 11, descending: true,
      :startkey => params[:startkey].to_i))["rows"]

    respond_to do |format|
      format.js { render :content_type => 'text/javascript' }
    end
  end

  def show
    @post = CouchPotato.database.load_document(params[:slug])
    @pub_date = @post.pubdate;

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def sitemap
    headers['Content-Type'] = 'application/xml'
    @posts = CouchPotato.database.view(Post.published())["rows"]

    respond_to do |format|
      format.xml { @posts }
    end
  end

end