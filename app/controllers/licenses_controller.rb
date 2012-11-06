class LicensesController < ApplicationController

  before_filter :check_distributor!

  rescue_from PCGuard::BadProgramID, :with => proc { |e| rescue_from_license_errors :application_id }
  rescue_from PCGuard::BadSiteCode, :with => proc { |e| rescue_from_license_errors :sitecode }
  rescue_from PCGuard::BadMID, PCGuard::MIDCodeError, :with => proc { |e| rescue_from_license_errors :mid }
  rescue_from License::ComputerNotRegistered, :with => :rescue_from_computer_not_registered
  rescue_from License::IncorrectRemovalCode, :with => :rescue_from_incorrect_removal_code

  # GET /licenses/new
  # GET /licenses/new.json
  def new
    @license = License.new
    @clients = current_user.distributor.clients
    @computers = []
    @applications = Application.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @license }
    end
  end

  def update_computers
    client = Client.find(params[:client_id])
    @computers = client.computers.map{|s| [s.name, s.id]}.insert(0, "Select a computer")
  end
  
  # POST /licenses
  # POST /licenses.json
  def create
    @license = License.new(params[:license])
    @license.user = current_user
    
    l = PCGuard.new(@license.application.ProgramID, @license.sitecode, @license.mid)
    @license.activation_code   = l.activation_code
    @license.removal_code      = l.removal_code
    @license.hd_volumen_serial = l.hd_volumen_serial
    @license.motherboard_bios  = l.motherboard_bios
    @license.cpu               = l.cpu
    @license.hard_drive        = l.hard_drive

    if @license.save
      respond_to do |format|
        format.html { redirect_to new_license_path, notice: 'License was successfully created.' }
        format.json { render json: @license, status: :created, location: @license }
      end
    else
      redirect_to_new_form
    end
      
  end
  
  # GET /licenses
  # GET /licenses.json
  def index
    @selected_client = params[:selected_client].try(:[], :id).presence
    @order = params[:order] || "application_id"
    @show_all = !!params[:show_all]
    if @selected_client
      @selected_client = current_user.distributor.clients.find @selected_client
      @licenses = @selected_client.licenses.search(params[:search]).order(@order)
      @licenses = @licenses.active unless @show_all
    else
      @licenses = []
    end
    @clients = current_user.distributor.clients

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @licenses }
    end
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
    @license = current_user.distributor.licenses.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @license }
    end
  end

  # GET /licenses/1/edit
  def edit
    @license = current_user.distributor.licenses.find(params[:id])
    raise License::NotActive unless @license.active?
    @license.sitecode = @license.mid = @license.notes = ""
  end

  # PUT /licenses/1
  # PUT /licenses/1.json
  def update
    @license = current_user.distributor.licenses.find(params[:id])

    if @license.renew(params[:license][:sitecode], params[:license][:mid], current_user, params[:license][:notes])
      respond_to do |format|
        format.html { redirect_to @license, notice: 'License was successfully renewed.' }
        format.json { head :no_content }
      end
    else
      redirect_to_edit_form
    end
  end

  # GET /licenses/1/remove
  def remove
    @license = current_user.distributor.licenses.find(params[:id])
    raise License::NotActive unless @license.active?
    @license.removal_code = @license.removal_reason = ""
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    @license = current_user.distributor.licenses.find(params[:id])

    if @license.remove(params[:license][:removal_code], current_user, params[:license][:removal_reason])
      respond_to do |format|
        format.html { redirect_to @license, notice: 'License was successfully removed.' }
        format.json { head :no_content }
      end
    else
      redirect_to_remove_form
    end
  end

  private
  
  def rescue_from_license_errors(field_error)
    @license.errors.add field_error
    redirect_to_new_form
  end
  
  def redirect_to_new_form
    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: @license.errors, status: :unprocessable_entity }
      @clients = current_user.distributor.clients
      if @license.computer.nil?
        @computers = []
      else
        @computers = @license.computer.client.computers
      end
      @applications = Application.all
    end
  end
  
  def rescue_from_computer_not_registered
    @license.errors.add :mid, "doesn't coincide with this computer"
    redirect_to_edit_form
  end
  
  def redirect_to_edit_form
    @license.assign_attributes sitecode: params[:license][:sitecode], mid: params[:license][:mid], notes: params[:license][:notes]
    respond_to do |format|
      format.html { render action: "edit" }
      format.json { render json: @license.errors, status: :unprocessable_entity }
    end
  end

  def rescue_from_incorrect_removal_code
    @license.errors.add :removal_code
    redirect_to_remove_form
  end
  
  def redirect_to_remove_form
    @license.assign_attributes removal_code: params[:license][:removal_code], removal_reason: params[:license][:removal_reason]
    respond_to do |format|
      format.html { render action: "remove" }
      format.json { render json: @license.errors, status: :unprocessable_entity }
    end
  end

end
