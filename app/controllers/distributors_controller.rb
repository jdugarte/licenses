class DistributorsController < ApplicationController

  before_filter :check_distributors_admin!

  # GET /distributors
  # GET /distributors.json
  def index
    @distributors = current_user.distributor.distributors

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @distributors }
    end
  end

  # GET /distributors/1
  # GET /distributors/1.json
  def show
    @distributor = current_user.distributor.distributors.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @distributor }
    end
  end

  # GET /distributors/new
  # GET /distributors/new.json
  def new
    @distributor = current_user.distributor.distributors.build
    @distributor.users.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @distributor }
    end
  end

  # GET /distributors/1/edit
  def edit
    @distributor = current_user.distributor.distributors.find(params[:id])
  end

  # POST /distributors
  # POST /distributors.json
  def create
    @distributor = current_user.distributor.distributors.build(params[:distributor])
    @distributor.users.first.admin = true

    respond_to do |format|
      if @distributor.save
        format.html { redirect_to @distributor, notice: 'Distributor was successfully created.' }
        format.json { render json: @distributor, status: :created, location: @distributor }
      else
        format.html { render action: "new" }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /distributors/1
  # PUT /distributors/1.json
  def update
    @distributor = current_user.distributor.distributors.find(params[:id])

    respond_to do |format|
      if @distributor.update_attributes(params[:distributor])
        format.html { redirect_to @distributor, notice: 'Distributor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributors/1
  # DELETE /distributors/1.json
  def destroy
    @distributor = current_user.distributor.distributors.find(params[:id])
    @distributor.destroy

    respond_to do |format|
      format.html { redirect_to distributors_url }
      format.json { head :no_content }
    end
  end
end
