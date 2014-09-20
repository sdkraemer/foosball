class CreateGameTeams < ActiveRecord::Migration
  def change
    create_table :game_teams do |t|

      t.timestamps
    end
  end
end
