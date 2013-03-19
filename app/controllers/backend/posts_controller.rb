class Backend::PostsController < Backend::BaseController
  layout "backend/backend"
  protect_from_forgery

  before_filter :authorize
  before_filter :initialize_sidebar, :only => [:edit, :new]

  def show
      @post = CouchPotato.database.load_document(params[:slug])

      stale? @post, public: true do
        respond_to do |format|
          format.html # show.html.erb
        end
      end

  end

  def edit
    @post = CouchPotato.database.load_document(params[:id])

    stale? @post, public: true do
      respond_to do |format|
        format.html
      end
    end
  end

  def update
    post = CouchPotato.database.load_document(params[:id])
    post.attributes = params[:post]
    post.state = params[:state]

    save_post = post

    if post.state != "published" && post.title_changed?
      new_post = Post.new post.attributes
      save_post = new_post

      CouchPotato.database.destroy_document post
    end

    if CouchPotato.database.save_document save_post
      redirect_to edit_backend_post_path(save_post)
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
        format.html {redirect_to backend_root_url, :alert => "Post successful deleted."}
        format.js { render :nothing => true, :status => 200 }
      end
    end
  end

end