class Game < ActiveRecord::Base
	belongs_to :teamone, class_name: 'Team', foreign_key: 'teamoneid'
	belongs_to :teamtwo, class_name: 'Team', foreign_key: 'teamtwoid'
end
