class AddColumnsToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :elevation, :integer
    add_column :steps, :position_type, :string
  end
end
