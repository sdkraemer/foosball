class Team < ActiveRecord::Base
  belongs_to :game
  has_many :positions, :dependent => :destroy
  has_many :goals
  enum color: {blue: 0, red: 1}

  accepts_nested_attributes_for :positions, :allow_destroy => true

  scope :winner, -> {where(winner: true)}
  scope :loser, -> {where.not(winner: true)}
  scope :blue, -> {where(color: 0)}
  scope :red, -> {where(color: 1)}

  def get_goals_total
  	@game = self.game
  	ourgoals = self.goals.where(quantity: 1)

  	other_team = self.game.teams.where.not(id: self.id).first

  	other_teams_own_goals = other_team.goals.where(quantity: -1)
  	return ourgoals.count + other_teams_own_goals.count
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
    other_team = game.teams.where.not(color: self.color).first
    scored_goals = self.goals.scored_goal.where(["created_at <= ?", goal.created_at]).count
    other_teams_own_goals = other_team.goals.own_goal.where(["created_at <= ?", goal.created_at]).count

    return scored_goals + other_teams_own_goals
  end

end
