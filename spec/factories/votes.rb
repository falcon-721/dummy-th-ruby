FactoryGirl.define do
  factory :vote do
    user
    association :voteable
    value 0
  end

  factory :vote_for_question, class: 'Vote' do
    user
    association :voteable, factory: :question
    value 0
  end

  factory :vote_for_answer, class: 'Vote' do
    user
    association :voteable, factory: :answer
    value 0
  end
end
