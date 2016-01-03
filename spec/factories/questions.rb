FactoryGirl.define do
  sequence :title do |n|
    "Question ##{n}"
  end

  factory :question do
    title
    body { Faker::Lorem.sentence }
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
