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
		scored_count = goals.where(quantity: 1).count
		own_goals_count = goals.where(quantity: -1).count
		
		@total_goals ||= (scored_count - own_goals_count)
	end

	def goals_per_game
		games_count = Goal.select(:game_id).uniq.where(player_id: self.id).count
		if games_count > 0
			(total_goals*1.0)/games_count
		else
			0
		end
	end

	def player_wins
		teams = Team.uniq.where(winner: true).joins(:positions).where(:positions => {:player_id => self.id})
		#Team.uniq.where(winner: true).joins(:positions).where(:positions => {:player_id => self.id}).count
		@wins ||= Game.where.not(completed_at: nil).where(id: teams.select(:game_id)).count
	end

	def player_losses
		teams = Team.uniq.where(winner: false).joins(:positions).where(:positions => {:player_id => self.id})
		@losses ||= Game.where.not(completed_at: nil).where(id: teams.select(:game_id)).count
	end

	def win_pct
		total_games = @wins.to_i+@losses.to_i
		if total_games > 0
			(@wins.to_i*1.0/total_games)*100
		else
			0
		end
	end
end
