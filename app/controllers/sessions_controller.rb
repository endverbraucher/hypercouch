class SessionsController < ApplicationController
  layout 'backend/backend'
  
  def new
    redirect_to backend_root_url unless session[:user_id].nil?
  end

  def create
    user = CouchPotato.database.load_document(params[:name])
    
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to backend_root_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end    
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :alert => "Logged out"
  end

end