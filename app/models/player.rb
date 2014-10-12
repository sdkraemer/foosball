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
		goals = self.goals
		scored_count = goals.scored_goal.count
		own_goals_count = goals.own_goal.count
		
		@total_goals ||= (scored_count - own_goals_count)
	end

	def player_games
		@player_games ||= Game.completed.joins(:teams).select("games.*, teams.winner").where(:teams => {:id => Position.select(:team_id).uniq.where(:player_id => self.id)} )
	end

	def goals_per_game
		total_games = player_games.count("games.id")
		if total_games > 0
			(total_goals*1.0)/total_games
		else
			0
		end
	end

	def player_wins
		@player_wins ||= player_games.where("teams.winner" => true).count("games.id")
	end

	def player_losses
		@player_losses ||= player_games.where("teams.winner" => false).count("games.id")
	end

	def win_pct
		games_count = player_games.count("games.id")
		winner_games_count = player_wins

		if games_count > 0
			((winner_games_count*1.0)/games_count)*100
		else
			0
		end
	end
end
