class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :location
      t.float :lon
      t.float :lat
      t.date :arrival
      t.integer :stay
      t.references :trip_id, index: true

      t.timestamps
    end
  end
end
