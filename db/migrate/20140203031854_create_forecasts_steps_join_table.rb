class CreateForecastsStepsJoinTable < ActiveRecord::Migration
  def change
      create_table :forecasts_steps, id: false do |t|
      t.integer :forecast_id
      t.integer :step_id
      end
  end
end
