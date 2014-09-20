class DropTeams < ActiveRecord::Migration
  def up
    drop_table :teams
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
