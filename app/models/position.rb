class Position < ActiveRecord::Base
  belongs_to :team
  belongs_to :player
  has_many :goals, :dependent => :destroy
  #has_one :game, :through => :team
  enum position_type: {goalie: 0, defense: 1, midfield: 2, striker: 3}

  #validators
  validates :position_type, uniqueness: {scope: :team_id}
  #TODO: must have player

  def self.striker
  	where(position_type: 3).first
  end

  def self.midfield
  	where(position_type: 2).first
  end

  def self.defense
  	where(position_type: 1).first
  end

  def self.goalie
  	where(position_type: 0).first
  end
end
