require 'spec_helper'

describe Team do 

	#Validations
	it "is invalid if same color team already exists" do
		game = Game.new
		
		first_blue = game.teams.build(color: :blue)
		second_blue = game.teams.build(color: :blue)
		game.save
		expect(second_blue).to be_invalid
	end

	it "is valid if two different color teams exist" do
		player_one = FactoryGirl.create(:player)
		player_two = FactoryGirl.create(:player)

		game = Game.new
		
		blue = game.teams.build(color: :blue)
		red = game.teams.build(color: :red)
		game.save

		#satisfy condition that teams must have four positions filled
		red.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
		red.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
		red.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
		red.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

		expect(red).to be_valid
	end

	it "is invalid if team set to winner and a winner already exists" do 
		game = Game.new
		
		blue = game.teams.build(color: :blue)
		red = game.teams.build(color: :red)
		game.save

		blue.winner = true
		blue.save

		red.winner = true
		red.save

		expect(red).to be_invalid
	end 

	it "is invalid if it has more than four positions" do 
		player_one = FactoryGirl.create(:player)
		player_two = FactoryGirl.create(:player)

		game = Game.new
		
		blue_team = game.teams.build(color: :blue)
		red_team = game.teams.build(color: :red)
		game.save

		#satisfy condition that teams must have four positions filled
		red_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_one.id)
		red_team.positions.build(position_type: Position.position_types["defense"], player_id: player_one.id)
		red_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_one.id)
		red_team.positions.build(position_type: Position.position_types["striker"], player_id: player_one.id)

		blue_team.positions.build(position_type: Position.position_types["goalie"], player_id: player_two.id)
		blue_team.positions.build(position_type: Position.position_types["defense"], player_id: player_two.id)
		blue_team.positions.build(position_type: Position.position_types["midfield"], player_id: player_two.id)
		blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)
		blue_team.positions.build(position_type: Position.position_types["striker"], player_id: player_two.id)

		expect(blue_team).to be_invalid
	end

#	describe '#get_team_score_at' do
#		before :each do 
#			player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
#			player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
#			game = Game.create()
#
#			@blue_team = game.teams.create(color: :blue)
#			@blue_team.positions.create(position_type: :striker, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :defense, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :goalie, player_id: player_one.id)
#
#			@red_team = game.teams.create(color: :red)
#			@red_team.positions.create(position_type: :striker, player_id: player_two.id)
#			@red_team.positions.create(position_type: :midfield, player_id: player_two.id)
#			@red_team.positions.create(position_type: :defense, player_id: player_two.id)
#			@red_team.positions.create(position_type: :goalie, player_id: player_two.id)
#		end 
#
#		it "counts a scored positive goal" do 
#			goal = @blue_team.positions.first.goals.create()
#
#			expect(@blue_team.get_team_score_at(goal)).to eq(1)
#		end
#
#		it "counts opposing teams own goals" do 
#			goal = @red_team.positions.first.goals.create(quantity: -1)
#
#			expect(@blue_team.get_team_score_at(goal)).to eq(1)
#		end
#	end
#
#	describe '#get_goals_total' do 
#		before :each do 
#			player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
#			player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
#			@game = Game.create()
#
#			@blue_team = @game.teams.create(color: :blue)
#			@blue_team.positions.create(position_type: :striker, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :defense, player_id: player_one.id)
#			@blue_team.positions.create(position_type: :goalie, player_id: player_one.id)
#
#			@red_team = @game.teams.create(color: :red)
#			@red_team.positions.create(position_type: :striker, player_id: player_two.id)
#			@red_team.positions.create(position_type: :midfield, player_id: player_two.id)
#			@red_team.positions.create(position_type: :defense, player_id: player_two.id)
#			@red_team.positions.create(position_type: :goalie, player_id: player_two.id)
#		end
#
#		it "counts scored goals" do
#			@blue_team.positions.last.goals.create()
#			expect(@blue_team.get_goals_total).to eq(1)
#		end
#
#		it "counts opposing teams own goals" do
#			@red_team.positions.last.goals.create(quantity: -1)
#			expect(@blue_team.get_goals_total).to eq(1)
#		end
#
#		it "counts both scored and opposing own goals together" do
#			@blue_team.positions.last.goals.create()
#			@red_team.positions.last.goals.create(quantity: -1)
#			expect(@blue_team.get_goals_total).to eq(2)
#		end 
#
#		it "scores to ten goals" do 
#			10.times {
#				@blue_team.positions.first.goals.create
#			}
#
#			expect(@blue_team.get_goals_total).to eq(10)
#		end
#
#		it "sets a winner after ten goals" do
#			10.times{
#				@blue_team.positions.first.goals.create
#			}
#
#			expect(@blue_team.reload.winner).to be true
#		end
#	end 
end
