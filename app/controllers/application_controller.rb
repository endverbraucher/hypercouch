class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
    if session[:user_id].nil?
      redirect_to login_url, :notice => "Please log in!"    
    end
  end
    
end
