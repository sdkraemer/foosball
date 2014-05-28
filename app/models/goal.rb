class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :position
end
