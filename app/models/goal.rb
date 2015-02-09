class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :position
  belongs_to :player

  after_save :complete_game
  before_save :timestamp

  scope :scored_goal, -> { where(quantity: 1)}
  scope :own_goal, -> { where(quantity: -1)}

  def timestamp
    scored_at = DateTime.now
  end

  #complete a game if a team reached 10 goals
  def complete_game
  	@game = self.game
  	isGameComplete = false

  	@game.teams.each do |team|
  		if team.get_goals_total == 10
  			team.winner = true
  			team.save
  			
  			@game.completed_at = DateTime.now
  			@game.save

        isGameComplete = true
  		end
  	end

  	#if undo occurred or bad data, unset completed_at
  	if not isGameComplete and @game.completed_at != nil
  		@game.completed_at = nil
  		@game.save

      #unset winner on teams
      @games.teams.each do |team|
        team.winner = false
        team.save
      end
  	end
  end

  def own_goal?
    if self.quantity > 0 then 
      false
    else
      true
    end
  end

  def blue_goal?
    return (self.team.blue? && !self.own_goal?) || (self.team.red? && self.own_goal?)
  end

  def red_goal?
    return (self.team.red? && self.quantity > 0) || (self.team.blue? && self.own_goal?)
  end
end
