json.array!(@forecasts) do |forecast|
  json.extract! forecast, :id, :location, :datetime, :lon, :lat, :temperature, :temp_min, :temp_max, :pressure, :humidity, :wind_speed, :wind_deg
  json.url forecast_url(forecast, format: :json)
end
