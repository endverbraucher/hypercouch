class Backend::DashboardController < Backend::BaseController
  protect_from_forgery
  before_filter :authorize
  before_filter :initialize_sidebar, :only => :index
  layout "backend/backend"

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new_idea
    @post = Post.new
    @post.attributes = params[:post]
    @post.id = @post.title.parameterize
    @post.state = "idea"

    CouchPotato.database.save_document @post

    respond_to do |format|
        format.js
    end

  end

end