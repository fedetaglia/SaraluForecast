class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.string :location
      t.timestamp :datetime
      t.float :lon
      t.float :lat
      t.float :temperature
      t.float :temp_min
      t.float :temp_max
      t.integer :pressure
      t.integer :humidity
      t.float :wind_speed
      t.float :wind_deg

      t.timestamps
    end
  end
end
