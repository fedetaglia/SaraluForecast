class AddColumnsToForecasts < ActiveRecord::Migration
  def change
    add_column :forecasts, :country, :string
    add_column :forecasts, :lon, :float
    add_column :forecasts, :lat, :float
    add_column :forecasts, :day, :datetime
    add_column :forecasts, :weather, :string
    add_column :forecasts, :description, :string
    add_column :forecasts, :temp_mor, :float
    add_column :forecasts, :temp_day, :float
    add_column :forecasts, :temp_eve, :float
    add_column :forecasts, :temp_nig, :float
    add_column :forecasts, :pressure, :float
    add_column :forecasts, :humidity, :integer
    add_column :forecasts, :speed, :float
    add_column :forecasts, :deg, :integer
    add_column :forecasts, :clouds, :integer
    add_column :forecasts, :rain, :integer
    add_column :forecasts, :created_at, :datetime
    add_column :forecasts, :updated_at, :datetime
  end
end
