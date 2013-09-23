class KillsController < ApplicationController
  # GET /kills
  # GET /kills.json
  def index
    @kills = Kill.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kills }
    end
  end

  # GET /kills/1
  # GET /kills/1.json
  def show
    @kill = Kill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kill }
    end
  end

  # GET /kills/new
  # GET /kills/new.json
  def new
    @kill = Kill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kill }
    end
  end

  # GET /kills/1/edit
  def edit
    @kill = Kill.find(params[:id])
  end

  # POST /kills
  # POST /kills.json
  def create
    @kill = Kill.new(params[:kill])

    respond_to do |format|
      if @kill.save
        format.html { redirect_to @kill, notice: 'Kill was successfully created.' }
        format.json { render json: @kill, status: :created, location: @kill }
      else
        format.html { render action: "new" }
        format.json { render json: @kill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kills/1
  # PUT /kills/1.json
  def update
    @kill = Kill.find(params[:id])

    respond_to do |format|
      if @kill.update_attributes(params[:kill])
        format.html { redirect_to @kill, notice: 'Kill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kills/1
  # DELETE /kills/1.json
  def destroy
    @kill = Kill.find(params[:id])
    @kill.destroy

    respond_to do |format|
      format.html { redirect_to kills_url }
      format.json { head :no_content }
    end
  end
end
