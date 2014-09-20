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
	validates :username, presence: true, 
						 length: { minimum: 4 }
	validates :firstname, presence: true
	validates :lastname, presence: true
end
