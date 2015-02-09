class GameDecorator < ApplicationDecorator
  delegate_all

  #decorates_association :goals

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def completed?
  	completed_at?
  end

  def winning_team_color
  	winner = object.teams.where(winner: true)[0]
  	if not winner.nil?
  		winner.color.humanize
  	else
  		""
  	end
  end

  def winning_team_class
  	winner = object.teams.where(winner: true)[0]
  	if not winner.nil?
  		"#{winner.color.downcase}team"
  	else
  		""
  	end
  end

  def scoring_player_name

  end

  def has_goals?
  	object.goals.count > 0
  end

  def goals_ordered
  	object.goals.order("created_at")
  end

  def completed_at
  	if completed_at?
  		object.completed_at.strftime("%A, %B %e, %Y %l:%M%P")
  	else
  		"Game in progress"
  	end
  end

  def td_players_game_result(player)
    winner_count = self.teams.winner.joins(:positions).where(:positions => {player_id: player.id}).count
    if winner_count > 0 then
      h.content_tag(:td, "Won", class: :success)
    else
      h.content_tag(:td, "Lost", class: :danger)
    end
  end

  def players_in_game
    team_players = []
    object.teams.each do |team|
      #push in a concatenated list of players per team, comma seperated
      team_players.push( team.positions.joins(:player).select("players.firstname").distinct("players.firstname").pluck(:firstname).map{|f| f.humanize}.join(",") )
    end
    team_players.join(" vs ")
  end

end
