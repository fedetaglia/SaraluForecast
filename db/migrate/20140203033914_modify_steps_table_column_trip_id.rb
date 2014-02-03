class ModifyStepsTableColumnTripId < ActiveRecord::Migration
  def change
    rename_column :steps, :trip_id_id, :trip_id
  end
end
