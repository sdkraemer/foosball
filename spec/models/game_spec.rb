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
  describe "validate associations" do

    before :each do
      @game = FactoryGirl.create(:game)
      team_one = @game.teams.create(color: :blue)
      team_two = @game.teams.create(color: :red)

      player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
      player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")

      team_one.positions.create(position_type: :striker, player_id: player_one.id)
      team_one.positions.create(position_type: :midfield, player_id: player_one.id)
      team_one.positions.create(position_type: :defense, player_id: player_one.id)
      team_one.positions.create(position_type: :goalie, player_id: player_one.id)

      team_two.positions.create(position_type: :striker, player_id: player_two.id)
      team_two.positions.create(position_type: :midfield, player_id: player_two.id)
      team_two.positions.create(position_type: :defense, player_id: player_two.id)
      team_two.positions.create(position_type: :goalie, player_id: player_two.id)

      goal = team_one.positions.first.goals.create()
    end 

    it "can access teams" do 
      expect(@game.teams.count).to eq(2)
    end

    it "can access positions" do 
      expect(@game.positions.count).to eq(8)
    end

    it "can access goals" do 
      expect(@game.goals.count).to eq(1)
    end
  end #validate associations

  describe "game flow" do 
    before :each do
      @game = Game.create()
      @blue_team = @game.teams.create(color: :blue)
      @red_team = @game.teams.create(color: :red)

      player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
      player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")

      @blue_team.positions.create(position_type: :striker, player_id: player_one.id)
      @blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
      @blue_team.positions.create(position_type: :defense, player_id: player_one.id)
      @blue_team.positions.create(position_type: :goalie, player_id: player_one.id)

      @red_team.positions.create(position_type: :striker, player_id: player_two.id)
      @red_team.positions.create(position_type: :midfield, player_id: player_two.id)
      @red_team.positions.create(position_type: :defense, player_id: player_two.id)
      @red_team.positions.create(position_type: :goalie, player_id: player_two.id)
    end

    it "completes game after ten goals" do 
      10.times {
        @blue_team.positions.first.goals.create(quantity: 1)
      }

      expect(@blue_team.reload.winner).to be true
    end
  end

end
