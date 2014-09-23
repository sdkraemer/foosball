class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :type
      t.references :player, index: true
      t.references :team, index: true

      t.timestamps
    end
  end
end
