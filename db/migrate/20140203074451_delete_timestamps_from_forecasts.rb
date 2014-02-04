class DeleteTimestampsFromForecasts < ActiveRecord::Migration
  def change
    remove_column :forecasts, :created_at
    remove_column :forecasts, :updated_at
  end
end
