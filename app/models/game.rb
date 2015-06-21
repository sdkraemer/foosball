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

	accepts_nested_attributes_for :teams, :allow_destroy => true
	
	enum color: [:red, :blue]

	scope :completed, -> { where.not(completed_at: nil) }

	validate :valid_if_two_teams

	#validators
	def valid_if_two_teams
		errors[:base] << "Games must include two teams." if teams.reject(&:marked_for_destruction?).count != 2
	end

	#Class Methods

	#builds new team based a passed in team. 
	#Shifts players one spot moving from goalie to striker
	private
	def self.shift_team(old_team)
		old_team_positions = old_team.positions.order(:position_type)
		new_team = Team.new
		if old_team.color == "red"
			new_team.color = "blue"
		else
			new_team.color = "red"
		end

		#Position.position_types.each do |position_key, position_value|
		4.times do |position_index|
 			position = new_team.positions.build
 			position.position_type = position_index

 			#shift players from goalie to striker. look at last game played
 			current_player_id = old_team_positions[position_index].player_id
 			l = (position_index-1)%4
 			found_teammate = false
 			while l != position_index
 				#puts "current_player_id:#{current_player_id} old_team_positions[l].player_id:#{old_team_positions[l].player_id}"
 				if current_player_id != old_team_positions[l].player_id
 					position.player_id = old_team_positions[l].player_id
 					found_teammate = true
 					break
 				end
 				l = (l-1)%4
 			end

 			#if no other player was found, means the entire team is the same player
 			if !found_teammate
 				position.player_id = current_player_id
 			end
 		end

 		return new_team
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
	def self.new_rematch_game(previous_game)
 		previous_red_team = previous_game.teams.red.first
 		previous_blue_team = previous_game.teams.blue.first

 		rematch_game = Game.new

 		blue_team = Game.shift_team(previous_red_team)
 		red_team = Game.shift_team(previous_blue_team)

 		rematch_game.teams << [blue_team, red_team]

 		return rematch_game
	end

	#Instance Methods

	#Passed eligible players
	def generate_random_teams(players)

		#randomize
		players = players.shuffle

		assign_players_to_teams(players)
	end

	def assign_players_to_teams(players)
		players.each_with_index do |player, index|
			if(index.even?)
 				self.teams[0].add_pending_player( player )
 			else
 				self.teams[1].add_pending_player( player )
 			end
		end
	end

	def setup_submit

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
