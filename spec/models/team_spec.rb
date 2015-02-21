require 'spec_helper'

describe Team do 

	describe '#get_team_score_at' do
		before :each do 
			player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
			player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
			game = Game.create()

			@blue_team = game.teams.create(color: :blue)
			@blue_team.positions.create(position_type: :striker, player_id: player_one.id)
			@blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
			@blue_team.positions.create(position_type: :defense, player_id: player_one.id)
			@blue_team.positions.create(position_type: :goalie, player_id: player_one.id)

			@red_team = game.teams.create(color: :red)
			@red_team.positions.create(position_type: :striker, player_id: player_two.id)
			@red_team.positions.create(position_type: :midfield, player_id: player_two.id)
			@red_team.positions.create(position_type: :defense, player_id: player_two.id)
			@red_team.positions.create(position_type: :goalie, player_id: player_two.id)
		end 

		it "counts a scored positive goal" do 
			goal = @blue_team.positions.first.goals.create()

			expect(@blue_team.get_team_score_at(goal)).to eq(1)
		end

		it "counts opposing teams own goals" do 
			goal = @red_team.positions.first.goals.create(quantity: -1)

			expect(@blue_team.get_team_score_at(goal)).to eq(1)
		end
	end

	describe '#get_goals_total' do 
		before :each do 
			player_one = Player.create(firstname: "Scott", lastname: "Kraemer", username: "Scott")
			player_two = Player.create(firstname: "Suzanne", lastname: "Nogami", username: "Suzanne")
			@game = Game.create()

			@blue_team = @game.teams.create(color: :blue)
			@blue_team.positions.create(position_type: :striker, player_id: player_one.id)
			@blue_team.positions.create(position_type: :midfield, player_id: player_one.id)
			@blue_team.positions.create(position_type: :defense, player_id: player_one.id)
			@blue_team.positions.create(position_type: :goalie, player_id: player_one.id)

			@red_team = @game.teams.create(color: :red)
			@red_team.positions.create(position_type: :striker, player_id: player_two.id)
			@red_team.positions.create(position_type: :midfield, player_id: player_two.id)
			@red_team.positions.create(position_type: :defense, player_id: player_two.id)
			@red_team.positions.create(position_type: :goalie, player_id: player_two.id)
		end

		it "counts scored goals" do
			@blue_team.positions.last.goals.create()
			expect(@blue_team.get_goals_total).to eq(1)
		end

		it "counts opposing teams own goals" do
			@red_team.positions.last.goals.create(quantity: -1)
			expect(@blue_team.get_goals_total).to eq(1)
		end

		it "counts both scored and opposing own goals together" do
			@blue_team.positions.last.goals.create()
			@red_team.positions.last.goals.create(quantity: -1)
			expect(@blue_team.get_goals_total).to eq(2)
		end 

		it "scores to ten goals" do 
			10.times {
				@blue_team.positions.first.goals.create
			}

			expect(@blue_team.get_goals_total).to eq(10)
		end

		it "sets a winner after ten goals" do
			10.times{
				@blue_team.positions.first.goals.create
			}

			expect(@blue_team.reload.winner).to be true
		end
	end 
end
