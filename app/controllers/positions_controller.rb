class PositionsController < ApplicationController
  def score
	position = Position.find(position_params[:id])

	goal = position.goals.build
	goal.quantity = position_params[:quantity]  ? position_params[:quantity] : 1

	goal.save
	redirect_to edit_game_path( position.team.game )

  	#position = Position.find_by_id(position_params[:id])
	#goalscored = position.goals.build
	#goalscored.player_id = position.player_id
	#goalscored.game_id = position_params[:game_id]
	#goalscored.team_id = position_params[:team_id]
	#if position_params[:quantity]
	#	goalscored.quantity = position_params[:quantity].to_i ? position_params[:quantity].to_i : 1
	#end
	#if goalscored.save
	#	@game = Game.find(position_params[:game_id])
	#	redirect_to edit_game_path(@game)
	#else
#
	#end
  end

  private
	  def position_params
	    params.permit(:id, :quantity)
	  end
end
