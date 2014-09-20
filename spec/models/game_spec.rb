# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Game do
  it "has valid factory" do
  	expect(FactoryGirl.create(:game)).to be_valid
  end

  it "is valid with one team" do
  	game_with_one_team = FactoryGirl.create :game_with_teams, number_of_teams: 1
  	expect(game_with_one_team).to be_valid
	end

	it "is valid with two team" do
  	game_with_two_team = FactoryGirl.create :game_with_teams, number_of_teams: 2
  	expect(game_with_two_team).to be_valid
	end

	it "is not valid with three team" do
  	game_with_three_team = FactoryGirl.create :game_with_teams, number_of_teams: 3
  	expect(game_with_three_team).not_to be_valid
	end

	it "is not valid with one team and started" do
		game = FactoryGirl.build :game_with_teams, started_at: Date.new(2012, 12, 3), number_of_teams: 1
		expect(game).not_to be_valid
	end

  it "is not valid with no teams and started date" do
		game = FactoryGirl.build :game_with_teams, started_at: Date.new(2012, 12, 3), number_of_teams: 0
		expect(game).not_to be_valid
	end

  it "is valid with two teams and started" do
		game = FactoryGirl.build :game_with_teams, started_at: Date.new(2012, 12, 3), number_of_teams: 2
		expect(game).to be_valid
	end


  it "is not valid with one team and goals" do
  	game = FactoryGirl.create:game_with_teams, number_of_teams: 1
  	
  end
end
