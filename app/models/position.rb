class Position < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  has_many :goals
  enum position: {striker: 0, midfield: 1, defense: 2, goalie: 3}
end
