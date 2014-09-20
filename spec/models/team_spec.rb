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

require 'spec_helper'

describe Team do
  it "has valid factory" do
  	expect(FactoryGirl.create(:team)).to be_valid
	end

  it "is invalid without striker" do
  	expect(FactoryGirl.build(:team, striker: nil)).not_to be_valid
  end

  it "is invalid without midfield"  do
  	expect(FactoryGirl.build(:team, midfield: nil)).not_to be_valid
  end

  it "is invalid without defense" do
  	expect(FactoryGirl.build(:team, defense: nil)).not_to be_valid
  end

  it "is invalid without goalie" do
  	expect(FactoryGirl.build(:team, goalie: nil)).not_to be_valid
  end

  it "has valid striker" do
  	team = FactoryGirl.create(:team)
  	expect(team.striker).to be_valid
  end

  it "is not empty striker name" do
  	expect(FactoryGirl.create(:team).striker.firstname).not_to be_empty
  end

end
