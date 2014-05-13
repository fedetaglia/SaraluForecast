class AddColumnToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :forecast_lat, :float
    add_column :steps, :forecast_lng, :float
  end
end
