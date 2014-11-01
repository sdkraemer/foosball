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
end
