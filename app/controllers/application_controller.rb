class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from License::NotActive, :with => :redirect_license_not_active

  private
  
  def check_admin!
    redirect_access_denied unless current_user.admin?
  end
  
  def check_main!
    redirect_access_denied unless current_user.admin? and current_user.distributor.main?
  end
  
  def check_distributor!
    redirect_access_denied unless current_user.distributor.dist?
  end
  
  def check_distributor_admin!
    redirect_access_denied unless current_user.admin? and current_user.distributor.dist?
  end
  
  def check_distributors_admin!
    redirect_access_denied if !current_user.admin? or current_user.distributor.dist?
  end
  
  def record_not_found(exception)
    model = exception.message.match(/Couldn't find (.*) with.*/)[1].downcase
    flash[:error] = "The #{model} you requested could not be found."
    redirect_to url_for(model.classify.constantize)
  end 
  
  private
  
  def redirect_access_denied
    flash[:warning] = "Access denied"
    redirect_to :root
  end
  
  def redirect_license_not_active
    flash[:warning] = "License not active"
    redirect_to licenses_path
  end

end
