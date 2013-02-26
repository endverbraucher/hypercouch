class Backend::DashboardController < ApplicationController
  protect_from_forgery
  before_filter :authorize
  layout "backend/backend"
  
  def index
    @post = Post.new
    @ideas = CouchPotato.database.view(Post.unpublished(descending: true))
    @published = CouchPotato.database.view(Post.published(descending: true))
    
    respond_to do |format|
      format.html # index.html.erb
    end    
  end
  
  def new_idea
    @post = Post.new
    @post.attributes = params[:post]
    @post.id = @post.title.parameterize
    @post.published = false
    
    CouchPotato.database.save_document @post
    
    respond_to do |format|
        format.js
    end
    
  end
  
end