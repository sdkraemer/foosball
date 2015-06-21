require 'spec_helper'

describe Position do 
	it "is invalid if a position already exists at that position type" do
		player_one = FactoryGirl.create(:player)
		player_two = FactoryGirl.create(:player)

		game = Game.new
		
		blue_team = game.teams.build(color: :blue)
		red_team = game.teams.build(color: :red)

		game.save

		blue_team.save
		red_team.save

		first_goalie = blue_team.positions.build(player_id: player_one.id, position_type: Position.position_types["goalie"])
		first_goalie.save

		second_goalie = blue_team.positions.build(player_id: player_one.id, position_type: Position.position_types["goalie"])
		
		expect(second_goalie).to be_invalid
	end
end