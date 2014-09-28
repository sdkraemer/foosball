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

	validate :teams_cannot_be_more_than_two, :game_cannot_be_started_without_two_teams

	accepts_nested_attributes_for :teams, :allow_destroy => true
	
	enum color: [:red, :blue]

	def teams_cannot_be_more_than_two
    errors[:base] = 'Games cannot have more than two teams' unless teams.size<=2
	end

	def game_cannot_be_started_without_two_teams
		if started_at != nil and teams.size < 2 
			errors[:base] = 'Games cannot be started without two teams' 
		end
	end
end
