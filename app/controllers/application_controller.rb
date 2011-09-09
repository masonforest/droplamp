class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  protect_from_forgery  
  helper_method :current_user  
  def index
    if current_user then
      redirect_to sites_path
    else
      render "pages/home"
    end
  end 
  def authenticate_user
   if !current_user then
      redirect_to root_path
    end

  end  
  private  
  def current_user 
    @current_user ||= User.find(session[:user_id].to_s) if session[:user_id]  
  end 


end
