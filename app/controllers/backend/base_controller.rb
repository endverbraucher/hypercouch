class Backend::BaseController <  ActionController::Base
  protect_from_forgery

  def initialize_sidebar
    @new_post = Post.new
    @ideas = CouchPotato.database.view(Post.ideas(descending: true))
    @in_review = CouchPotato.database.view(Post.in_review(descending: true))
    @published = CouchPotato.database.view(Post.published(descending: true))
  end

  def authorize
    if session[:user_id].nil?
      redirect_to login_url, :notice => "Please log in!"
    end
  end

end
