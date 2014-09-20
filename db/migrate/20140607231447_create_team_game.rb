class CreateTeamGame < ActiveRecord::Migration
  def change
    	#create_table :team_games do |t|
    	create_join_table :game, :team
  end
end
