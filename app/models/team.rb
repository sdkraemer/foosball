class Team < ActiveRecord::Base
  belongs_to :game
  has_many :positions
   enum color: {blue: 0, red: 1}
end
