class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :quantity
      t.timestamp :scored_at
      t.references :position, index: true

      t.timestamps
    end
  end
end
