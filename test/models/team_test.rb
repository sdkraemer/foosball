require 'test_helper'
 
class TeamTest < ActiveSupport::TestCase
  test "test positions not filled" do
  	teamone = Team.new
  	assert_not teamone.save, "Saved team without positions filled"
  end

  test "test positions filled" do
  	player = Player.new
  	player.username = "sdkraemer"
  	player.firstname = "scott"
  	player.lastname = "kraemer"
  	player.save

  	playertwo = Player.new
  	playertwo.username = "snogami"
  	playertwo.firstname = "suzanne"
  	playertwo.lastname = "nogami"
  	playertwo.save

  	teamone = Team.new
  	teamone.striker_id = player.id
  	teamone.midfield_id = player.id
  	teamone.defense_id = playertwo.id
  	teamone.goalie_id = playertwo.id

  	assert teamone.save, "Saved team with positions filled"
  end

  
end