class Team < ActiveRecord::Base
  belongs_to :game
  has_many :positions, :dependent => :destroy
  has_many :goals, :through => :positions


  enum color: {blue: 0, red: 1}

  accepts_nested_attributes_for :positions, :allow_destroy => true

  scope :winner, -> {where(winner: true)}
  scope :loser, -> {where.not(winner: true)}
  scope :blue, -> {where(color: 0)}
  scope :red, -> {where(color: 1)}

  #add a player to the pending player list
  def add_pending_player(player)
    if(!@pending_players)
      @pending_players = [] 
    end

    @pending_players << player
  end

  def pending_players
    @pending_players
  end

  def opposing_team
    @opposing_team ||= self.game.teams.where.not(id: self.id).first
  end

  def get_goals_total
  	game = self.game
  	scored_goals = self.goals.scored_goal

  	#opposing_team_own_goals = game.teams.where.not(id: self.id).first.goals.own_goal
    opposing_team_own_goals = opposing_team.goals.own_goal

  	return scored_goals.count + opposing_team_own_goals.count
  end

  def self.new_team(game)
    team = game.teams.build

    4.times{ team.positions.build }
    team.positions[3].position_type = :striker
    team.positions[2].position_type = :midfield
    team.positions[1].position_type = :defense
    team.positions[0].position_type = :goalie

    return team
  end

  def get_team_score_at(goal)
    game = self.game
    scored_goals = self.goals.scored_goal.where(["goals.created_at <= ?", goal.created_at]).count


    opposing_team = game.teams.where.not(id: self.id).first
    opposing_teams_own_goals = opposing_team.goals.own_goal.where(["goals.created_at <= ?", goal.created_at]).count

    return scored_goals + opposing_teams_own_goals
  end

  def players_list
    self.positions.joins(:player).select("players.firstname").distinct("players.firstname").pluck(:firstname).map{|f| f.humanize}.join(",")
  end

end
