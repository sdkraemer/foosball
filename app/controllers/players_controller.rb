class PlayersController < ApplicationController
  def new
  	@player = Player.new
  end

	def index
		@player = Player.new
		@players = Player.all
	end

  def create
  	@player = Player.new(player_params)
 
  	#if @player.save
		#	format.html { redirect_to edit_player_path(@player), notice: 'Player created successfully.' }
		#	format.json { render json: @player }
		#	format.js { render action: "show", status: :created, location: @player}
		#else
		#	format.html { redirect_to edit_player_path(@player), notice: 'Player created successfully.' }
		#end

		if @player.save
			redirect_to edit_player_path(@player)
		else
			render :new
		end
	end

	def update
		@player = Player.find(params[:id])
		if @player.update(player_params)
			redirect_to edit_player_path(@player)
		else
			render edit_player_path(@player)
		end	
	end


  def edit
    @player = Player.find(params[:id])
  end

  def show
  	@player = Player.find(params[:id])
  end

  private
	  def player_params
	    params.require(:player).permit(:username, :firstname, :lastname)
	  end

  
end
