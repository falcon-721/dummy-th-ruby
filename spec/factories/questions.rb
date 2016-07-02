FactoryGirl.define do
  sequence :title do |n|
    "Question ##{n}"
  end

  factory :question do
    title
    body { Faker::Lorem.sentence }
    user

    trait :faker do
      title { "#{Faker::Hacker.say_something_smart}?" }
    end

    transient do
      votes_num 0
    end

    after(:create) do |q, ev|
      q.votes = create_list(:vote, ev.votes_num, :random, votable: q)
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
