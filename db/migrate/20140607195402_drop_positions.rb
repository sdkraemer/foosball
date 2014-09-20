class DropPositions < ActiveRecord::Migration
  def up
    drop_table :positions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
