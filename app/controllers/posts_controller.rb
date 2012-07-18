class PostsController < ApplicationController
  
  def index
    @posts = CouchPotato.database.view(Post.published(limit: 11, descending: true))["rows"]

    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.json { render json: @posts }
    end
  end
  
  def more
    @posts = CouchPotato.database.view(Post.published(stale: 'ok', limit: 11, descending: true, :startkey => params[:startkey].to_i))["rows"]
    
    respond_to do |format|
      format.js { render :content_type => 'text/javascript' }
    end    
  end

  def show
    @post = CouchPotato.database.load_document(params[:slug])
    
    unless @post.published
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def sitemap
    headers['Content-Type'] = 'application/xml'
    @posts = CouchPotato.database.view(Post.published())["rows"]
    latest = @posts.last["value"]
        
    if stale?(:etag => latest, :last_modified => latest.updated_at.utc)
      respond_to do |format|
        format.xml { @posts }
      end
    end
  end
  
end