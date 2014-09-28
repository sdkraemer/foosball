class Team < ActiveRecord::Base
  belongs_to :game
  has_many :positions, :dependent => :destroy
  has_many :goals
  enum color: {blue: 0, red: 1}
  accepts_nested_attributes_for :positions, :allow_destroy => true
end
