class TransfersController < ApplicationController

  before_filter :check_distributor!

  rescue_from PCGuard::BadProgramID, :with => proc { |e| rescue_from_license_errors :application_id }
  rescue_from PCGuard::BadSiteCode, :with => proc { |e| rescue_from_license_errors :sitecode }
  rescue_from PCGuard::BadMID, PCGuard::MIDCodeError, :with => proc { |e| rescue_from_license_errors :mid }
  rescue_from License::ComputerNotRegistered, :with => :rescue_from_computer_not_registered
  rescue_from License::IncorrectRemovalCode, :with => :rescue_from_incorrect_removal_code

  # GET /transfers/1
  def new
    @license = current_user.distributor.licenses.find(params[:id])
    raise License::NotActive unless @license.active?
    @license.sitecode = @license.mid = @license.notes = @license.removal_code = ""
  end

  # PUT /transfers/1
  # PUT /transfers/1.json
  def update
    @license = current_user.distributor.licenses.find(params[:id])
    l = params[:license]
    computer = Computer.find l[:computer_id]

    if @license.transfer(computer, l[:removal_code], l[:sitecode], l[:mid], current_user, l[:notes])
      respond_to do |format|
        format.html { redirect_to @license, notice: 'License was successfully transfered.' }
        format.json { head :no_content }
      end
    else
      redirect_to_transfer_form
    end
  end

  private
  
  def redirect_to_transfer_form
    @license.assign_attributes params[:license]
    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: @license.errors, status: :unprocessable_entity }
    end
  end

  def rescue_from_license_errors(field_error)
    @license.errors.add field_error
    redirect_to_transfer_form
  end
  
  def rescue_from_computer_not_registered
    @license.errors.add :mid, "doesn't coincide with this computer"
    redirect_to_transfer_form
  end
  
  def rescue_from_incorrect_removal_code
    @license.errors.add :removal_code
    redirect_to_transfer_form
  end
  
end
