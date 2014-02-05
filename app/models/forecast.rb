class Forecast < ActiveRecord::Base
  has_and_belongs_to_many :steps



def self.new_from_owm(answer,index = 0)
  forecast = answer['list'][index]
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
