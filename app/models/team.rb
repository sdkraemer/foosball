# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  striker_id  :integer
#  midfield_id :integer
#  defense_id  :integer
#  goalie_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Team < ActiveRecord::Base
	has_many :game_teams
	has_many :games, through: :game_teams
	belongs_to :striker, :class_name => "Player"
	belongs_to :midfield, :class_name => "Player"
	belongs_to :defense, :class_name => "Player"
	belongs_to :goalie, :class_name => "Player"

	validates :striker_id, presence: true
	validates :midfield_id, presence: true
	validates :defense_id, presence: true
	validates :goalie_id, presence: true

	accepts_nested_attributes_for :games
end
