class DeleteColumnFromForecasts < ActiveRecord::Migration
  def change
    remove_column :forecasts, :datetime
    remove_column :forecasts, :temperature
    remove_column :forecasts, :temp_min
    remove_column :forecasts, :temp_max
    remove_column :forecasts, :pressure
    remove_column :forecasts, :humidity
    remove_column :forecasts, :wind_speed
    remove_column :forecasts, :wind_deg
    remove_column :forecasts, :lon
    remove_column :forecasts, :lat
  end
end
