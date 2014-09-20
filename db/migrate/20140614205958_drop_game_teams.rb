class DropGameTeams < ActiveRecord::Migration
  def up
    drop_table :game_teams
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
