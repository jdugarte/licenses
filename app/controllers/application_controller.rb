class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  protect_from_forgery
  
  private
  
  def check_admin!
    redirect_to :root if !current_user.admin?
  end
  
end
