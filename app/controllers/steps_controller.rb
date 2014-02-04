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
        make_forecast
        if @forecast.present?
          format.html { redirect_to [@trip, @step], notice: 'Step was successfully created.' }
          format.json { render action: 'show', status: :created, location: @step }
        else
          format.html { 
            flash.now[:notice] = "Cannot make forecast for #{@step.location}. City not found!" 
            render action: 'new' }
          format.json { render json: @step.errors, status: :unprocessable_entity }
        end
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
        binding.pry
        if !have_forecast?
          make_forecast
          if @forecast.present?
            format.html { redirect_to [@trip, @step], notice: 'Step was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { 
              flash.now[:notice] = "Cannot make forecast for #{@step.location}. City not found!" 
              render action: 'edit' 
              }
            format.json { render json: @step.errors, status: :unprocessable_entity }      
          end
        end
        format.html { redirect_to [@trip, @step], notice: 'Step was successfully updated. No new forecast needed' }
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


    def have_forecast?
      # look for last forecast for the step in a specific date

      latest = @step.forecasts.where('day = ?', @step.arrive_on.beginning_of_day).order('created_at desc').first
      
      # if I have it I check if it's new (created today) and if the user has or not changed the location
      if latest.present?
        Time.now.to_date == latest.created_at.to_date && @step.location == latest.location + ',' + latest.country
      else
        false
      end
    end


    def make_forecast

      position = @step.location
      string = "http://api.openweathermap.org/data/2.5/forecast/daily?q=" + position + '&type=accurate&&cnt=14&units=metric&APPID=f1b24a078a85fd4bfcd63f4d91f4dd4a'
      search = URI.escape(string)
      @answer = HTTParty.get(search) 

      if @answer['city'] != nil

        # @answer['list'].each do |day|
        #   if @step.arrive_on == (Time.at day['dt']).to_date
        #     @forecast = day
        #   end
        # end

        arrive_on_index = @answer['list'].index {|day| (Time.at day['dt']).to_date == @step.arrive_on }

        arrive_on_index.upto(arrive_on_index+@step.stay-1) do |index|    
          forecast = @answer['list'][index]
          add_forecast = Forecast.new(
              :location => @answer['city']['name'],
              :country => @answer['city']['country'],
              :lon => @answer['city']['coord']['lon'],
              :lat => @answer['city']['coord']['lat'],
              :day => (Time.at forecast['dt']).to_date,
              :weather => forecast['weather'][0]['main'],
              :description => forecast['weather'][0]['description'],
              :temp_mor => forecast['temp']['morn'],
              :temp_day => forecast['temp']['day'],
              :temp_eve => forecast['temp']['eve'],
              :temp_nig => forecast['temp']['night'],
              :pressure => forecast['pressure'],
              :humidity =>forecast['humidity'],
              :speed => forecast['speed'],
              :deg => forecast['deg'],
              :clouds => forecast['clouds'],
              :rain => forecast['rain']
            )
          @step.forecasts << add_forecast
        end

        @step.location = @answer['city']['name'] + "," + @answer['city']['country']
        @step.lon = @answer['city']['coord']['lon']
        @step.lat = @answer['city']['coord']['lat']

        @step.save
      end
    end

end
