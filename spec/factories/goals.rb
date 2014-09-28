# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :goal, :class => 'Goals' do
    scored_at "2014-09-27 15:58:42"
    team nil
    position nil
  end
end
