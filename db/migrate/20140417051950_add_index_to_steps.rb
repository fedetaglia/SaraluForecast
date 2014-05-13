class AddIndexToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :index, :integer
  end
end
