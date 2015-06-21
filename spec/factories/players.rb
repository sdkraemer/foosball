#require 'faker'

FactoryGirl.define do
	sequence :username do |n|
		#Faker giving usernames less than four characters, so this way I force it to be 4
	    username = Faker::Internet.user_name
	    if username.length < 4 then
	    	username = username+("#{n}"*(4-username.length))
	    end
	    username
  	end

	factory :player do |f|
		sequence(:username) { |n| "user#{n}" }
		f.firstname {Faker::Name.first_name}
		f.lastname {Faker::Name.last_name}
		sequence(:email)  { |n| "email#{n}@email.com" }
		f.password "password"
		#f.username "sdkraemer"
		#f.firstname "Scott"
		#f.lastname "Kraemer"
	end
end