FactoryGirl.define do
  sequence :title do |n|
    "Question ##{n}"
  end

  factory :question do
    title
    body "MyText"
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
