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

  			isGameComplete = true
  			
  			@game.completed_at = DateTime.now
  			@game.save
  		end
  	end

  	#if undo occurred or bad data, unset completed_at
  	if not isGameComplete and @game.completed_at != nil
  		@game.completed_at = nil
  		@game.save
  	end
  end
end
