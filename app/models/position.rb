class Position < ActiveRecord::Base
  belongs_to :team
  belongs_to :player

  #enum position_type: [ :striker, :midfield, :defense, :goalie ]
end
