class PositionsController < ApplicationController
  def score
  	position = Position.find_by_id(position_params[:id])
		goalscored = position.goals.build
		goalscored.player_id = position.player_id
		goalscored.game_id = position_params[:game_id]
		goalscored.team_id = position_params[:team_id]
		if position_params[:quantity]
			goalscored.quantity = position_params[:quantity].to_i
		end
		if goalscored.save
			@game = Game.find(position_params[:game_id])
			redirect_to edit_game_path(@game)
		else

		end
  end

  private
	  def position_params
	    params.permit(:game_id, :team_id, :id, :player_id, :quantity)
	  end
end
