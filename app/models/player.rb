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
		scored_goals = Game.completed.joins(:goals).merge(Goal.scored_goal).select("goals.id").where(:goals => {:player_id => self.id}).count
		own_goals = Game.completed.joins(:goals).merge(Goal.own_goal).select("goals.id").where(:goals => {:player_id => self.id}).count
		
		@total_goals ||= (scored_goals - own_goals)
	end

	def player_games
		@player_games ||= Game.uniq.completed.joins(:teams).joins(:positions).where(:positions => {:player_id => self.id})

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
