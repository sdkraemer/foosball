require 'spec_helper'

RSpec.describe Goal, :type => :model do
#  describe "after_save" do
#  	before :each do 
#  		player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
#		player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
#		@game = Game.create()
#
#		@blue_team = @game.teams.create(color: :blue)
#		@blue_team.positions.create(position_type: :striker, player_id: player_one.id)
#		@blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
#		@blue_team.positions.create(position_type: :defense, player_id: player_one.id)
#		@blue_team.positions.create(position_type: :goalie, player_id: player_one.id)
#
#		@red_team = @game.teams.create(color: :red)
#		@red_team.positions.create(position_type: :striker, player_id: player_two.id)
#		@red_team.positions.create(position_type: :midfield, player_id: player_two.id)
#		@red_team.positions.create(position_type: :defense, player_id: player_two.id)
#		@red_team.positions.create(position_type: :goalie, player_id: player_two.id)
#
#		#create nine goals, so in the test the last one is run
#		9.times {
#			@blue_team.positions.first.goals.create()
#		}
#  	end 
#
#  	it "should set team as winner" do
#  		@blue_team.positions.first.goals.create
#  		expect(@blue_team.reload.winner).to be true
#  	end
#
#  	it "should set the game to complete" do
#  		@blue_team.positions.first.goals.create
#  		expect(@blue_team.reload.game.completed_at).to_not be_nil
#  	end 
#  end
end
