class AddIndexToTeam < ActiveRecord::Migration
  def change
  	add_index :teams, [:striker_id, :midfield_id, :defense_id, :goalie_id], :unique => true, :name => 'team_uniqueness_index'
  end
end
