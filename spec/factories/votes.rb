FactoryGirl.define do
  factory :vote do
    user
    association :votable, factory: :question
    value 1

    trait :random do
      value { [-1, 1].sample }
    end
  end
end
