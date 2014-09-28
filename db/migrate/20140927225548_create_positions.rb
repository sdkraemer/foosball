class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :position_type
      t.references :team, index: true
      t.references :player, index: true

      t.timestamps
    end
  end
end
