class AddColumnsToForecast < ActiveRecord::Migration
  def change
    add_column :forecasts, :temp_max, :integer
    add_column :forecasts, :temp_min, :integer
    add_column :forecasts, :winddirection, :string
  end
end
