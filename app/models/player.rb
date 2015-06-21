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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
	has_many :positions
	has_many :goals

	validates :username, presence: true, 
						 length: { minimum: 4 }
	validates :firstname, presence: true
	validates :lastname, presence: true

	#subtracts own goals
	def total_goals
		return @total_goals if defined? @total_goals

		scored_goals = my_goals.merge(Goal.scored_goal).count
		own_goals = my_goals.merge(Goal.own_goal).count

		
		@total_goals ||= (scored_goals - own_goals)
	end

	def player_games
		@player_games ||= Game.uniq.completed.joins(:teams).joins(:positions).where("teams.id = positions.team_id").where(:positions => {:player_id => self.id})
	end

	def goals_per_game
		return 0 if my_completed_games.count == 0
		(total_goals*1.0)/my_completed_games.count
	end

	def goals_per_stick
		total_positions = self.positions.joins(:team => :game).merge(Game.completed).count

		if total_positions > 0
			(total_goals*1.0)/total_positions
		else
			0
		end
	end

	def editable?
  	return player_signed_in? && (current_player.admin? || current_player.id == self.id)
  end

	def player_wins
		@player_wins ||= completed_teams.merge(Team.winner).count
	end

	def player_losses
		@player_losses ||= completed_teams.merge(Team.loser).count
	end

	def win_percentage
		return 0 if my_completed_games.count == 0
		((player_wins*1.0)/my_completed_games.count)*100
	end

	def my_completed_games
		return @my_completed_games if defined? @my_completed_games

		@my_completed_games ||= Game.uniq.completed.joins(:teams).joins(:positions).where(:positions => {player_id: self.id})
	end

	#teams on completed games
	def completed_teams
		return @completed_teams if defined? @completed_teams
		@completed_teams ||= Team.uniq.joins(:positions).where(:positions => {:player_id => self.id}).joins(:game).merge(Game.completed)
	end

	def my_goals 
		return @my_goals if defined? @my_goals
		@my_goals ||= Goal.joins(:position => {:team => :game}).where(:positions => {player_id: self.id}).merge(Game.completed)
	end

	def plus_minus
		return @plus_minus if defined? @plus_minus

		opposing_teams = Team.joins(:game).where(:games => {id: my_completed_games}).where.not(:teams => {id: completed_teams}).uniq

		completed_teams_scored_goals = Goal.scored_goal.joins(:position => :team).where(:teams => {id: completed_teams}).count
		completed_teams_own_goals = Goal.own_goal.joins(:position => :team).where(:teams => {id: completed_teams}).count

		opposing_teams_scored_goals = Goal.scored_goal.joins(:position => :team).where(:teams => {id: opposing_teams}).count
		opposing_teams_own_goals = Goal.own_goal.joins(:position => :team).where(:teams => {id: opposing_teams}).count

		@plus_minus ||= completed_teams_scored_goals + opposing_teams_own_goals - opposing_teams_scored_goals - completed_teams_own_goals
	end

	def margin
		return 0 if my_completed_games.count == 0

		(plus_minus*1.0)/my_completed_games.count

	end
end
