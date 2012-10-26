class ComputersController < ApplicationController

  before_filter :check_dist!
  before_filter :load_client

  # GET /clients/1/computers/1/edit
  def edit
    @computer = @client.computers.find(params[:id])
  end

  # PUT /clients/1/computers/1
  # PUT /clients/1/computers/1.json
  def update
    @computer = @client.computers.find(params[:id])

    respond_to do |format|
      if @computer.update_attributes(params[:computer])
        format.html { redirect_to @client, notice: 'Computer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  
    def load_client
      @client = current_user.distributor.clients.find(params[:client_id])
    end

end
