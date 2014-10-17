# == Schema Information
#
# Table name: games
#has_many :game_team
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Game < ActiveRecord::Base
	has_many :teams, :dependent => :destroy
	has_many :goals, :dependent => :destroy

	validate :teams_cannot_be_more_than_two
	#, :game_cannot_be_started_without_two_teams

	accepts_nested_attributes_for :teams, :allow_destroy => true
	
	enum color: [:red, :blue]

	scope :completed, -> { where.not(completed_at: nil) }

	def teams_cannot_be_more_than_two
    errors[:base] = 'Games cannot have more than two teams' unless teams.size<=2
	end

	def winning_team
		winningteam = self.teams.where(winner: true)
	end

	def is_finished
		if self.completed_at 
			true
		else
			false
		end
	end

	def undo_last_goal
		if self.completed_at != nil
			self.completed_at = nil
			self.teams.each do |team|
				team.winner = nil
				team.save
			end
			self.save
		end

		lastgoal = self.goals.order("created_at").last
 		lastgoal.delete
	end

# def game_cannot_be_started_without_two_teams
#		if started_at != nil and teams.size < 2 
#			errors[:base] = 'Games cannot be started without two teams' 
#		end
#	end
end
