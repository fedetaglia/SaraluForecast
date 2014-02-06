require 'uri'
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
    user_input = params[:location]
    location = Step.find_by_location(user_input)

    if location 
      @locations = user_input
    else
      string = "http://api.openweathermap.org/data/2.5/find?q=" + user_input + "&units=metric&mode=json&APPID=458002016608cfef4cc4518dfa32cd04"   
      answer = HTTParty.get(URI.escape(string)) 

      if answer['list'].count == 0
          # back to trip_path motice = 'location not found'
      else
        @locations = []
        answer['list'].each do |loc|
          @locations << loc['name'] + ',' + loc['sys']['country']
        end
      end
    end
    @step = @trip.steps.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  # POST /steps.json
  def create
    @step = @trip.steps.new(step_params)
    @locations = JSON params['locations']

    respond_to do |format|
      if @step.valid?
        if @step.save
          if @step.have_updated_forecast? # return true or false
            format.html { redirect_to @trip, notice: 'Step was successfully created. Updated forecast available.' }
            format.json { render action: 'show', status: :created, location: @step }
          else
            if @step.should_make_forecast?
              if @step.make_forecast == true # return true , false or nil
                format.html { redirect_to @trip, notice: 'Step was successfully created. New forecast requested.' }
                format.json { render action: 'show', status: :created, location: @step }
              else @step.make_forecast == false
                  format.html { 
                    flash.now[:notice] = "Cannot make forecast for #{@step.location}. City not found!" 
                    render action: 'new' }
                  format.json { render json: @step.errors, status: :unprocessable_entity }
              end
            else
                format.html { redirect_to @trip, notice: 'Step was successfully created. No forecast available for the arrival.' }
                format.json { render action: 'show', status: :created, location: @step }   
            end         
          end
        else
          format.html { render action: 'new' }
          format.json { render json: @step.errors, status: :unprocessable_entity }
        end
      else
        format.html { 
          flash.now[:notice] = "Cannot make forecast for #{@step.location}. Arrive on should be in the past!" 
          render action: 'new' }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
        
    end

  end

  # PATCH/PUT /steps/1
  # PATCH/PUT /steps/1.json
  def update

    respond_to do |format|
      if @step.update(step_params)
        if @step.have_updated_forecast? # return true or false
          format.html { redirect_to [@trip, @step], notice: 'Step was successfully updated. Update forecast available.' }
          format.json { head :no_content }
        else
          if @step.make_forecast # return true or nil
            format.html { redirect_to [@trip, @step], notice: 'Step was successfully updated.New forecast requested.' }
            format.json { head :no_content }
          else
            format.html { 
              flash.now[:notice] = "Cannot make forecast for #{@step.location}. City not found!" 
              render action: 'edit' 
              }
            format.json { render json: @step.errors, status: :unprocessable_entity }      
          end
        end
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
      format.html { redirect_to @trip }
      format.json { head :no_content }
    end
  end

  private

    def set_trip
      if params[:trip_id].present?
        @trip = current_user.trips.find_by_id params[:trip_id]
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = @trip.steps.find_by_id params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def step_params
      params.require(:step).permit(:location, :lon, :lat, :arrive_on, :stay, :trip_id)
    end


end
