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
	has_many :positions, :through => :teams
	has_many :players, :through => :positions
	has_many :goals, :through => :positions
	
	

	validate :teams_cannot_be_more_than_two
	#, :game_cannot_be_started_without_two_teams

	accepts_nested_attributes_for :teams, :allow_destroy => true
	
	enum color: [:red, :blue]

	scope :completed, -> { where.not(completed_at: nil) }


	#builds new team based a passed in team. 
	#Shifts players one spot moving from goalie to striker
	private
	def self.set_rematch_team(old_team, new_team)
		4.times do |old_team_index|
 			position = new_team.positions.build
 			position.position_type = old_team_index

 			#shift players from goalie to striker. look at last game played
 			current_player_id = old_team[old_team_index].player_id
 			l = (old_team_index-1)%4
 			while l != old_team_index
 				if current_player_id != old_team[l].player_id
 					position.player_id = old_team[l].player_id
 					break
 				end
 				l = (l-1)%4
 			end
 		end
	end


	public
	def self.new_game
		game = self.new

 		#create the blue team
 		blueteam = Team.new_team(game)
 		blueteam.color = "blue"

 		#create the red team
 		redteam = Team.new_team(game)
 		redteam.color = "red"

 		return game
	end

	#Handles how we rematch games.
	#Teams rotate on table and each player is shifted a position over
	def self.new_rematch_game(params)
		lastgame = Game.includes(teams: [:positions]).find_by_id(params[:id])
 		lastredteam = lastgame.teams.red.first.positions.order("positions.position_type")
 		lastblueteam = lastgame.teams.blue.first.positions.order("positions.position_type")

 		rematch_game = self.new

 		#create the blue team
 		blueteam = rematch_game.teams.build
 		blueteam.color = "blue"

 		set_rematch_team(lastredteam, blueteam)

 		#create the red team
 		redteam = rematch_game.teams.build
 		redteam.color = "red"

 		set_rematch_team(lastblueteam, redteam)

 		return rematch_game
	end

	#Passed eligible players
	def generate_random_teams(players)
		team_index = 0
		blue_team = nil
		red_team = nil
		self.teams.each do |team|
			if team.color == "red"
				red_team = team
			elsif team.color == "blue"
				blue_team = team
			end
		end

		#randomize
		players = players.shuffle

		players.each do |player|
			if(team_index.odd?)
 				blue_team.add_pending_player( player )
 			else
 				red_team.add_pending_player( player )
 			end

			team_index += 1
		end
	end

	def winning_team
		self.teams.where(winner: true).first
	end

	def losing_team
		self.teams.where(winner: false).first
	end

	def undo_last_goal
		if self.completed_at != nil
			self.completed_at = nil
			self.teams.each do |team|
				team.winner = false
				team.save
			end
			self.save
		end

		lastgoal = self.goals.order("created_at").last
 		lastgoal.destroy
	end


	#the following methods have the potential to be moved into a decorator
	def is_finished
		if self.completed_at 
			true
		else
			false
		end
	end

	def is_in_progress
		if not self.completed_at 
			true
		else
			false
		end
	end

	#give player, returns true or false for if the player was on the winning team of the game
	def did_player_win?(player)
		winner_count = self.teams.winner.joins(:positions).where(:positions => {player_id: player.id}).count
		return winner_count > 0
	end

	def team(player)
		self.teams.joins(:positions).where(:positions => {player_id: player.id}).first
	end

	#validators
	def teams_cannot_be_more_than_two
    	errors[:base] = 'Games cannot have more than two teams' unless self.teams.size <= 2
	end

	#goals scored by the passed in player
	def goals_scored(player)
		self.positions.where("positions.player_id = ?",player.id).joins(:goals).merge(Goal.scored_goal).count
	end
	
# def game_cannot_be_started_without_two_teams
#		if started_at != nil and teams.size < 2 
#			errors[:base] = 'Games cannot be started without two teams' 
#		end
#	end
end
