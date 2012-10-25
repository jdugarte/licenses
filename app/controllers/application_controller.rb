class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
  
  def check_admin!
    redirect_to :root if !current_user.admin? or current_user.distributor.dist?
  end
  
  def record_not_found(exception)
    model = exception.message.match(/Couldn't find (.*) with.*/)[1].downcase
    flash[:error] = "The #{model} you requested could not be found."
    redirect_to url_for(model.classify.constantize)
  end 
    
end
