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

require 'spec_helper'

describe Player do
	before{ @player = FactoryGirl.build(:player, username: "sdkraemer")}
	subject{@player}

	it {should be_valid}

	it "has a valid factory" do
		player = FactoryGirl.create(:player)
		expect(player).to be_valid
	end

	it "is invalid without username" do
		expect(FactoryGirl.build(:player, username: nil)).not_to be_valid
	end

	it "is invalid with username less than four characters" do
		expect(FactoryGirl.build(:player, username: "tny")).not_to be_valid
	end

	it "is invalid without first name" do
		@player.firstname = nil
		expect(@player).not_to be_valid
	end

	it "is invalid without last name" do
		@player.lastname = nil
		expect(@player).not_to be_valid
	end

end
