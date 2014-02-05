class Step < ActiveRecord::Base
  belongs_to :trip
  has_and_belongs_to_many :forecasts
  
  validate :arrive_on_is_greather_or_equal_than_today? 
  validates_numericality_of :stay, :only_integer => true
  validates_numericality_of :stay, :greater_than => 0

  Fdays_owm = 13 # future days for which openweathermap.org gives forecasts - 1 (ex. 14 days - today = 13)

  def arrive_on_is_greather_or_equal_than_today?
    if  self.arrive_on < Time.now.to_date  
      # error
      errors.add(:arrive_on,'should not be in the past')
    end
  end

  # here a check if the step needs forecasts
  # if step in the past do not need to update
  # if step is more more in advance then the api max day do not need to update

  def have_updated_forecast? # return true or false 
      # look for last forecast for the step in a specific date
      latest = self.forecasts.where('day = ?', self.arrive_on.beginning_of_day).order('created_at desc').first
      # if I have it I check if it's new (created today) and if the user has or not changed the location
      if latest.present?
        Time.now.to_date == latest.created_at.to_date && self.location == latest.location + ',' + latest.country
        # return true
      else
        # check if self.location has 1 only comma
        location, country = self.location.split(',')
        no_forecast_on = []
        0.upto(self.stay - 1 ) do |i|
          day = self.arrive_on + i
          forecast = Forecast.where('location = ? AND country = ? AND day = ?', location, country, day).order('created_at desc').first
          if forecast == nil
            no_forecast_on << day
          else
            self.forecasts << forecast
            self.lon = forecast.lon
            self.lat = forecast.lat
            self.save
          end
        end
        if no_forecast_on.empty?
          true
        else
          false
        end
      end
  end


  def make_forecast
    if !day_needs_forecast?(self.arrive_on)
      # arrive_on do not need forecast
      if !day_needs_forecast?(self.arrive_on + self.stay)
        # also the final day do not need forecast
        nil
      else
        self.function_for_making_forecast
      end
    else
      self.function_for_making_forecast
    end
  end
    
  def should_make_forecast?
    if self.arrive_on > Time.now + Fdays_owm
      false
    else
      true
    end
  end

  def function_for_making_forecast

      position = self.location
      string = "http://api.openweathermap.org/data/2.5/forecast/daily?q=" + position + '&type=accurate&&cnt=14&units=metric&APPID=458002016608cfef4cc4518dfa32cd04'
      search = URI.escape(string)
      answer = HTTParty.get(search) 
      if answer['city'] != nil && answer['list'] != nil
        arrive_on_index = answer['list'].index {|day| (Time.at day['dt']).to_date == self.arrive_on }
        arrive_on_index.upto(arrive_on_index+self.stay-1) do |index|    
          self.forecasts << Forecast.new_from_owm(answer, index)  # attirbutes : json from owm and index of array to be used
        end
        self.location = answer['city']['name'] + "," + answer['city']['country']
        self.lon = answer['city']['coord']['lon']
        self.lat = answer['city']['coord']['lat']
        self.save
        true
      else
        false
      end
  end


  def day_needs_forecast?(day) # return true or false
    if day < Time.now.to_date
      false
    elsif day > Time.now.to_date + Fdays_owm
      false
    else
      true
    end
  end


end
