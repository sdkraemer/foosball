FactoryGirl.define do
	#factory :player do |f|
	#	f.username {Faker::Internet.user_name}
	#	f.firstname {Faker::Name.first_name}
	#	f.lastname {Faker::Name.last_name}
	#end

	factory :team do |f|
		f.association :striker, factory: :player
		f.association :midfield, factory: :player
		f.association :defense, factory: :player
		f.association :goalie, factory: :player
	end

	
end