class Position < ActiveRecord::Base
  belongs_to :team
  belongs_to :player
  has_many :goals, :dependent => :destroy
  enum position_type: {goalie: 0, defense: 1, midfield: 2, striker: 3}


end
