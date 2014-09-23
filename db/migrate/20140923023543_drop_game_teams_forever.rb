class DropGameTeamsForever < ActiveRecord::Migration
  def change
  	drop_table :game_teams
  end
end
