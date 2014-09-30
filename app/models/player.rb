# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#

class Player < ActiveRecord::Base
	has_many :positions
	has_many :goals

	validates :username, presence: true, 
						 length: { minimum: 4 }
	validates :firstname, presence: true
	validates :lastname, presence: true

	#subtracts own goals
	def total_goals
		scored_count = self.goals.where(quantity: 1).count
		own_goals_count = self.goals.where(quantity: -1).count
		scored_count - own_goals_count
	end
end
