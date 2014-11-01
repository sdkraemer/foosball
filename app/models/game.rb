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


	def self.new_game(params)
		game = self.new

 		#create the blue team
 		blueteam = game.teams.build
 		blueteam.color = "blue"
 		4.times{ blueteam.positions.build }
 		blueteam.positions[3].position_type = :striker
 		blueteam.positions[2].position_type = :midfield
 		blueteam.positions[1].position_type = :defense
 		blueteam.positions[0].position_type = :goalie

 		#create the red team
 		redteam = game.teams.build
 		redteam.color = "red"
 		4.times{ redteam.positions.build}

 		redteam.positions[3].position_type = :striker
 		redteam.positions[2].position_type = :midfield
 		redteam.positions[1].position_type = :defense
 		redteam.positions[0].position_type = :goalie

 		return game
	end

	def self.new_rematch_game(params)
		lastgame = Game.includes(teams: [:positions]).find_by_id(params[:id])
 		lastredteam = lastgame.teams.red.first.positions.order("positions.position_type")
 		lastblueteam = lastgame.teams.blue.first.positions.order("positions.position_type")

 		rematch_game = self.new

 		#create the blue team
 		blueteam = rematch_game.teams.build
 		blueteam.color = "blue"
 		4.times do |last_team_index|
 			position = blueteam.positions.build
 			position.position_type = last_team_index

 			#shift players from goalie to striker. look at last game played
 			current_player_id = lastredteam[last_team_index].player_id
 			new_team_index = (last_team_index-1)%4
 			while new_team_index != last_team_index
 				if current_player_id != lastredteam[new_team_index].player_id
 					position.player_id = lastredteam[new_team_index].player_id
 					break
 				end
 				new_team_index = (new_team_index-1)%4
 			end
 		end

 		#create the red team
 		redteam = rematch_game.teams.build
 		redteam.color = "red"

 		4.times do |last_team_index|
 			position = redteam.positions.build
 			position.position_type = last_team_index

 			#shift players from goalie to striker. look at last game played
 			current_player_id = lastblueteam[last_team_index].player_id
 			l = (last_team_index-1)%4
 			while l != last_team_index
 				if current_player_id != lastblueteam[l].player_id
 					position.player_id = lastblueteam[l].player_id
 					break
 				end
 				l = (l-1)%4
 			end
 		end

 		return rematch_game
	end

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
