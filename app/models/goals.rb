class Goals < ActiveRecord::Base
	belongs_to :game
  belongs_to :team
  belongs_to :position
  belongs_to :player
end
