class ProcessController < ApplicationController

  before_filter :check_distributor_admin!

  # GET /process
  # GET /process.json
  def index
    @licenses = License.unprocessed
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @licenses }
    end
  end

  def update
    unless params[:license].blank?
      ids = params[:license].select { |id, selected| selected == "1" }.keys
      unless ids.empty?
        method = case params[:commit]
                   when "Approve" then :approve!
                   when "Reject"  then :reject!
                   else nil
                 end
        unless method.nil?
          rows = License.send(method, ids)
          flash[:notice] = "#{rows} #{'license'.pluralize(rows)} #{method == :approve! ? 'approved' : 'rejected'}" unless rows.zero?
        end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to process_url }
      format.json { head :no_content }
    end
  end
end
