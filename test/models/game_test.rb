require 'test_helper'
 
class GameTest < ActiveSupport::TestCase
  test "create game" do
  	game = Game.new
  	assert game.save, "Game with no team saved"
  end

  test "assign team to game" do
  	

  	game = Game.new
  	game.save

  	teamone = game.teams.build

  	player = Player.new
  	player.save

  	teamone = Team.new
  	teamone.striker_id = player.id
  	teamone.midfield_id = player.id
  	teamone.defense_id = player.id
  	teamone.goalie_id = player.id

  	teamone.save
  	refute_empty game.teams.first
  end
end