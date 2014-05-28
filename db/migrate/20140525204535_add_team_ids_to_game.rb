class AddTeamIdsToGame < ActiveRecord::Migration
  def change
  	add_column :games, :teamoneid, :string
  	add_column :games, :teamtwoid, :string
  end
end
