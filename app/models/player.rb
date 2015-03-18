# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#

class Player < ActiveRecord::Base
	has_many :positions
	has_many :goals

	validates :username, presence: true, 
						 length: { minimum: 4 }
	validates :firstname, presence: true
	validates :lastname, presence: true

	#subtracts own goals
	def total_goals
		return @total_goals if defined? @total_goals
		scored_goals = Game.completed.joins(:goals).merge(Goal.scored_goal).select("goals.id").where(:goals => {:player_id => self.id}).count
		own_goals = Game.completed.joins(:goals).merge(Goal.own_goal).select("goals.id").where(:goals => {:player_id => self.id}).count
		
		@total_goals ||= (scored_goals - own_goals)
	end

	def player_games
		@player_games ||= Game.uniq.completed.joins(:teams).joins(:positions).where("teams.id = positions.team_id").where(:positions => {:player_id => self.id})

		#@player_games ||= Game.completed.joins(:teams).select("games.id").where(:teams => {:id => Position.select(:team_id).uniq.where(:player_id => self.id)} )
	end

	def goals_per_game
		total_games = player_games.count("games.id")
		if total_games > 0
			(total_goals*1.0)/total_games
		else
			0
		end
	end

	def goals_per_stick
		total_positions = Game.completed.joins(:positions).where(:positions => {player_id: self.id}).count
		if total_positions > 0
			(total_goals*1.0)/total_positions
		else
			0
		end
	end

	def player_wins
		@player_wins ||= player_games.merge(Team.winner).count
	end

	def player_losses
		@player_losses ||= player_games.merge(Team.loser).count
	end

	def win_percentage

		if player_games.count > 0
			((player_wins*1.0)/player_games.count)*100
		else
			0
		end
	end

	def plus_minus
		games = Game.completed.joins(:teams, :positions).where(:positions => {player_id: self.id})

		


		my_games = Game.uniq.completed.joins(:teams, :positions).where(:positions => {player_id: self.id})
		my_teams_goals = 0
		opposing_teams_goals = 0

		my_games.each do |game|
			my_team = game.team(self)
			opposing_team = my_team.opposing_team

			my_teams_goals += my_team.get_goals_total
			opposing_teams_goals += opposing_team.get_goals_total
		end
		my_teams_goals - opposing_teams_goals
	end
end
