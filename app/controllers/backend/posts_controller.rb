class Backend::PostsController < ApplicationController
  layout "backend/backend"
  protect_from_forgery

  before_filter :authorize    

  def edit
    @post = CouchPotato.database.load_document(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @post = CouchPotato.database.load_document(params[:id])    
    @post.attributes = params[:post]
    @post.published = params[:published]    
    
    if !@post.published && @post.title_changed?      
      new_post = Post.new @post.attributes
      
      if CouchPotato.database.save_document new_post
        if CouchPotato.database.destroy @post
          render :js => "window.location = '" + edit_backend_post_path(new_post.id) + "'"
        end
      end
    else
      if CouchPotato.database.save_document @post
        respond_to do |format|        
          format.js
        end
      end
    end
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new
    @post.attributes = params[:post]
    
    CouchPotato.database.save_document @post
    
    respond_to do |format|
        format.js { render :edit }
    end
  end
  
  def destroy
    @post = CouchPotato.database.load_document(params[:id])    
    
    begin
      CouchPotato.database.destroy(@post)
    rescue ArgumentError
      logger.error "Atempt to delete invalid Document #{params[:id]}"
      respond_to do |format|
        format.js { render :json => "Deletion of Document failed.", :status => :unprocessable_entity }
      end
    else
      respond_to do |format|
        format.js { render :nothing => true, :status => 200 }
      end            
    end
  end
end
