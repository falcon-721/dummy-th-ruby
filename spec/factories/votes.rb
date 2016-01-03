FactoryGirl.define do
  factory :vote do
    user
    association :votable, factory: :question
    value 1
  end
end
