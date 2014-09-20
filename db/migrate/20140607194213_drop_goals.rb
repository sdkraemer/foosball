class DropGoals < ActiveRecord::Migration
  def up
    drop_table :goals
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
