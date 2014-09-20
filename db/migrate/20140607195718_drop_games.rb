class DropGames < ActiveRecord::Migration
  def up
    drop_table :games
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
