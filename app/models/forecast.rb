class Forecast < ActiveRecord::Base
  has_and_belongs_to_many :steps

def self.new_from_wwo(answer,index=0,loc_array) # http://developer.worldweatheronline.com/
  forecast = answer['data']['weather'][index]
  if forecast
    add_forecast = Forecast.new(
              :lon => loc_array[3],
              :lat => loc_array[0],
              :day => forecast['date'].to_date,
              :weather => nil,  
              :description => forecast['weatherDesc'][0]['value'],
              :temp_max => forecast['tempMaxC'],
              :temp_min => forecast['tempMinC'],
              :pressure => nil,
              :humidity => nil,
              :speed => forecast['windspeedKmph'],
              :deg => forecast['winddirDegree'],
              :winddirection => forecast['winddirection'],
              :clouds => nil,
              :rain => forecast['precipMM']
      )
  end
end

def self.new_from_owm(answer,index = 0)
  forecast = answer['list'][index]
  if forecast
  add_forecast = Forecast.new(
              :location => answer['city']['name'],
              :country => answer['city']['country'],
              :lon => answer['city']['coord']['lon'],
              :lat => answer['city']['coord']['lat'],
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
  end
end

end
