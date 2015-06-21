class GamesController < ApplicationController

 	def index
 	end

 	def create
 		#todo: Need to whitelist parameters. Did this to get it working initially
 		@game = Game.new(game_params)
 		if @game.save
 			redirect_to edit_game_path(@game)
 		else
 			render :new
 		end
 	end

 	def new
 		#all of this will be moved to a service object or in the model. Refactored soon
 		@game = Game.new_game
 		@players = Player.all.order(:firstname)

 		@blue_team_players = Player.all.order(:firstname)
 		@red_team_players = Player.all.order(:firstname)

 	end

 	def edit
 		#@game = Game.includes(teams: [positions: [:goals]]).order("teams.color, positions.position_type desc").find(params[:id])

 		@game = Game.includes(teams: [positions: [goals: [:player]]]).find(params[:id]).decorate
 		@redteam = @game.teams.red.first
 		@blueteam = @game.teams.blue.first
 		@positions = Position.position_types
 	end

 	def show
 	end

 	def update
 	end

 	def destroy
 		game = Game.find(params[:id])

 		if game.destroy then 
 			redirect_to games_path
 		else
 			redirect_to games_path, flash: {error: "Something went wrong. Please try again"}
 		end
 	end

 	def undo
 		game = Game.find_by_id(undo_params[:id])
 		game.undo_last_goal
 		redirect_to edit_game_path(game)
 	end

 	def index
 		@games = GameDecorator.decorate_collection(Game.order("created_at desc").paginate(:page => params[:page], :per_page => 10))
 	end

 	def rematch
 		#all of this will be moved to a service object or in the model. Refactored soon
 		#need to whitelist params
 		previous_game = Game.includes(teams: [:positions]).find_by_id(params[:id])

 		@game = Game.new_rematch_game(previous_game)

 		@players = Player.all.order(:firstname)

 		@blue_team_players = Player.all.order(:firstname)
 		@red_team_players = Player.all.order(:firstname)

 		render :action => :new
 	end

 	def add_player
 		selected_players = Player.find(setup_params[:player_id])

		selected_players_id = selected_players.map(&:id)
 		available_players = Player.where.not(id: selected_players_id)

 		render partial: "setup_game_modal", locals: { selected_players: selected_players, available_players: available_players, game: nil }
 	end

 	def remove_player
 		player_ids = setup_params[:player_id]
 		#remove player id from selected list
 		player_ids.delete(setup_params[:remove_id])

 		selected_players = Player.find(player_ids)
 		
 		selected_players_id = selected_players.map(&:id)
 		available_players = Player.where.not(id: selected_players_id)

 		render partial: "setup_game_modal", locals: { selected_players: selected_players, available_players: available_players, game: nil }
 	end

 	def player_dropdown
 		selected_players_id = setup_params[:selected_players_id]
 		if selected_players_id == nil
 			selected_players_id = []
 		end

 		if setup_params[:commit] == "Add Player"
 			selected_players_id << setup_params[:add_id]
 		elsif setup_params[:commit] == "Remove Player"
 			if setup_params[:remove_player_id]
 				selected_players_id.delete(setup_params[:remove_player_id])
 			end
 		end

		selected_players = Player.find(selected_players_id)

 		available_players = Player.where.not(id: selected_players_id)

 		render partial: "player_list", locals: { selected_players: selected_players, available_players: available_players } 
 	end

 	#need to move this to model or service object
 	def generate_teams
 		#seems redundant..just want to make sure I have actual players. Could remove this and stick with what is passed in player_id params
 		selected_players = Player.find(setup_params[:player_id])
 		selected_players_id = selected_players.map(&:id)
 		available_players = Player.where.not(id: selected_players_id)

 		game = Game.new_game
 		game.generate_random_teams(selected_players);

 		render partial: "setup_game_modal", locals: { selected_players: selected_players, available_players: available_players, game: game}
 	end

 	def setup_submit
 		@game = Game.new_game

 		@players = Player.all.order(:firstname)

 		@blue_team_players = Player.find(setup_params[:blue_team])
 		@red_team_players = Player.find(setup_params[:red_team])

 		render :new
 	end

 	private
	  def game_params
	    params.require(:game).permit( :id, :teams_attributes => [:id, :color, :positions_attributes => [:id, :player_id, :position_type]])
	  end

	  def undo_params
	  	params.permit(:id)
	  end

	  def setup_params
	  	params.permit(:id, :commit, :remove_player_id, :remove_id, :add_id, :player_id => [], :blue_team => [], :red_team => [])
	  end
end
