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
  #Validations
  it "is invalid with less than two teams" do
    game = Game.new
    game.teams.build(color: :blue)
    game.valid?
    expect(game.errors[:base]).to include("Games must include two teams.")
  end

  it "is invalid with more than two teams" do
    game = Game.new
    game.teams.build(color: :blue)
    game.teams.build(color: :red)
    game.teams.build(color: :red)
    game.valid?
    expect(game.errors[:base]).to include("Games must include two teams.")
  end

  it "is valid with two teams" do 
    player_one = FactoryGirl.create(:player)
    player_two = FactoryGirl.create(:player)

    game = Game.new
    blue_team = game.teams.build(color: :blue)
    red_team = game.teams.build(color: :red)

    red_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
    red_team.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
    red_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
    red_team.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

    blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_two.id)
    blue_team.positions.build(position_type: Position.position_types["defense"], player_id: player_two.id)
    blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_two.id)
    blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)

    expect(game).to be_valid
  end


  #Class Methods
  describe ".shift_team(old_team)" do 

    it "sets red team to blue" do
      player_one = FactoryGirl.create(:player)
      player_two = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)

      previous_game.save

      new_team = Game.shift_team(red_team)

      expect(new_team.color).to eq("blue")
    end

    it "sets blue team to red" do 
      player_one = FactoryGirl.create(:player)
      player_two = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)

      previous_game.save

      new_team = Game.shift_team(blue_team)

      expect(new_team.color).to eq("red")
    end

    it "sets new team to same player in all positions when the team is only one player" do
      player_one = FactoryGirl.create(:player)
      player_two = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_two.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)

      previous_game.save

      new_team = Game.shift_team(blue_team)

      expect(new_team.positions[ Position.position_types["goalie"] ].player_id).to eq(player_two.id)
      expect(new_team.positions[ Position.position_types["defense"] ].player_id).to eq(player_two.id)
      expect(new_team.positions[ Position.position_types["midfield"] ].player_id).to eq(player_two.id)
      expect(new_team.positions[ Position.position_types["striker"] ].player_id).to eq(player_two.id)

    end

    it "moves offense to defense and defense to offense when there are two players on the team." do
      red_player = FactoryGirl.create(:player)
      blue_defense = FactoryGirl.create(:player)
      blue_offense = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: red_player.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: blue_defense.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: blue_defense.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: blue_offense.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: blue_offense.id)

      previous_game.save

      new_team = Game.shift_team(blue_team)

      expect(new_team.positions[ Position.position_types["goalie"] ].player_id).to eq(blue_offense.id)
      expect(new_team.positions[ Position.position_types["defense"] ].player_id).to eq(blue_offense.id)
      expect(new_team.positions[ Position.position_types["midfield"] ].player_id).to eq(blue_defense.id)
      expect(new_team.positions[ Position.position_types["striker"] ].player_id).to eq(blue_defense.id)

    end

    it "moves goalie to defender, defender to offensive sticks and offense to goalie when three players are on a team." do
      red_player = FactoryGirl.create(:player)
      blue_goalie = FactoryGirl.create(:player)
      blue_defender = FactoryGirl.create(:player)
      blue_offense = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: red_player.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: blue_goalie.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: blue_defender.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: blue_offense.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: blue_offense.id)

      previous_game.save

      new_team = Game.shift_team(blue_team)

      expect(new_team.positions[ Position.position_types["goalie"] ].player_id).to eq(blue_offense.id)
      expect(new_team.positions[ Position.position_types["defense"] ].player_id).to eq(blue_goalie.id)
      expect(new_team.positions[ Position.position_types["midfield"] ].player_id).to eq(blue_defender.id)
      expect(new_team.positions[ Position.position_types["striker"] ].player_id).to eq(blue_defender.id)

    end

    it "shifts all players over in direction of goalie to striker when four players are on a team" do
      red_player = FactoryGirl.create(:player)
      blue_goalie = FactoryGirl.create(:player)
      blue_defender = FactoryGirl.create(:player)
      blue_midfield = FactoryGirl.create(:player)
      blue_offense = FactoryGirl.create(:player)

      previous_game = Game.new
      red_team = previous_game.teams.build(color: :red)
      blue_team = previous_game.teams.build(color: :blue)

      red_team.positions.build(position_type: Position.position_types["goalie"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["defense"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["midfield"], player_id: red_player.id)
      red_team.positions.build(position_type: Position.position_types["striker"], player_id: red_player.id)

      blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: blue_goalie.id)
      blue_team.positions.build(position_type: Position.position_types["defense"], player_id: blue_defender.id)
      blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: blue_midfield.id)
      blue_team.positions.build(position_type: Position.position_types["striker"], player_id: blue_offense.id)

      previous_game.save

      new_team = Game.shift_team(blue_team)

      expect(new_team.positions[ Position.position_types["goalie"] ].player_id).to eq(blue_offense.id)
      expect(new_team.positions[ Position.position_types["defense"] ].player_id).to eq(blue_goalie.id)
      expect(new_team.positions[ Position.position_types["midfield"] ].player_id).to eq(blue_defender.id)
      expect(new_team.positions[ Position.position_types["striker"] ].player_id).to eq(blue_midfield.id)

    end
  end  

  describe ".new_game" do 
    it "creates two teams" do 
      game = Game.new_game

      expect(game.teams.size).to eq(2)
    end
  end


  describe ".new_rematch_game" do
    #test game has two teams, red and blue with include
  end

  #Instance Methods
  describe "#assign_players_to_teams" do
    it "evenly distributes even number of players" do
      player_one = FactoryGirl.create(:player)
      player_two = FactoryGirl.create(:player)

      game = Game.new
      red_team = game.teams.build(color: :red)
      blue_team = game.teams.build(color: :blue)

      players = [player_one, player_two]
      game.assign_players_to_teams(players)

      expect(game.teams[0].pending_players.size).to eq(1)
      expect(game.teams[1].pending_players.size).to eq(1)
    end

    it "evenly distributes odd number of players" do
      player_one = FactoryGirl.create(:player)
      player_two = FactoryGirl.create(:player)
      player_three = FactoryGirl.create(:player)

      game = Game.new
      red_team = game.teams.build(color: :red)
      blue_team = game.teams.build(color: :blue)

      players = [player_one, player_two, player_three]
      game.assign_players_to_teams(players)

      expect(game.teams[0].pending_players.map{|p| p.id}).to eq([player_one.id, player_three.id])
      expect(game.teams[1].pending_players.map{|p| p.id}).to eq([player_two.id])
    end
  end

#
#    before :each do
#      @game = FactoryGirl.create(:game)
#      team_one = @game.teams.create(color: :blue)
#      team_two = @game.teams.create(color: :red)
#
#      player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
#      player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
#
#      team_one.positions.create(position_type: :striker, player_id: player_one.id)
#      team_one.positions.create(position_type: :midfield, player_id: player_one.id)
#      team_one.positions.create(position_type: :defense, player_id: player_one.id)
#      team_one.positions.create(position_type: :goalie, player_id: player_one.id)
#
#      team_two.positions.create(position_type: :striker, player_id: player_two.id)
#      team_two.positions.create(position_type: :midfield, player_id: player_two.id)
#      team_two.positions.create(position_type: :defense, player_id: player_two.id)
#      team_two.positions.create(position_type: :goalie, player_id: player_two.id)
#
#      goal = team_one.positions.first.goals.create()
#    end 
#
#    it "can access teams" do 
#      expect(@game.teams.count).to eq(2)
#    end
#
#    it "can access positions" do 
#      expect(@game.positions.count).to eq(8)
#    end
#
#    it "can access goals" do 
#      expect(@game.goals.count).to eq(1)
#    end
#  end #validate associations
#
#  describe "game flow" do 
#    before :each do
#      @game = Game.create()
#      @blue_team = @game.teams.create(color: :blue)
#      @red_team = @game.teams.create(color: :red)
#
#      player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
#      player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
#
#      @blue_team.positions.create(position_type: :striker, player_id: player_one.id)
#      @blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
#      @blue_team.positions.create(position_type: :defense, player_id: player_one.id)
#      @blue_team.positions.create(position_type: :goalie, player_id: player_one.id)
#
#      @red_team.positions.create(position_type: :striker, player_id: player_two.id)
#      @red_team.positions.create(position_type: :midfield, player_id: player_two.id)
#      @red_team.positions.create(position_type: :defense, player_id: player_two.id)
#      @red_team.positions.create(position_type: :goalie, player_id: player_two.id)
#    end
#
#    it "completes game after ten goals" do 
#      10.times {
#        @blue_team.positions.first.goals.create(quantity: 1)
#      }
#
#      expect(@blue_team.reload.winner).to be true
#    end

end
