class StepsController < ApplicationController
  before_action :set_trip
  before_action :set_step, only: [:show, :edit, :update, :destroy]

  # GET /steps
  # GET /steps.json
  def index
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
  end

  # GET /steps/new
  def new
    @step = @trip.steps.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  # POST /steps.json
  def create
    @step = @trip.steps.new(step_params)

    respond_to do |format|
      if @step.save
        format.html { redirect_to @step, notice: 'Step was successfully created.' }
        format.json { render action: 'show', status: :created, location: @step }
      else
        format.html { render action: 'new' }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /steps/1
  # PATCH/PUT /steps/1.json
  def update
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to @step, notice: 'Step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step.destroy
    respond_to do |format|
      format.html { redirect_to steps_url }
      format.json { head :no_content }
    end
  end

  private

    def set_trip
      if params[:trip_id].present?
        @trip = Trip.find_by_id params[:trip_id]
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def step_params
      params.require(:step).permit(:location, :lon, :lat, :arrival, :stay, :trip_id)
    end
end
