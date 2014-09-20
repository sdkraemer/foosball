class ChangeGameTeamsName < ActiveRecord::Migration
  def change
  	rename_table :game_team, :game_teams
  end
end
