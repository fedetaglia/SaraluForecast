class ChangeStepsRenameColumnArrival < ActiveRecord::Migration
  def change
    change_table :steps do |t|
      t.rename :arrival, :arrive_on
    end
  end
end
