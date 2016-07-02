FactoryGirl.define do
  factory :answer do
    question
    body { Faker::Lorem.sentence }
    user

    transient do
      votes_num 0
    end

    after(:create) do |a, ev|
      a.votes = create_list(:vote, ev.votes_num, :random, votable: a)
    end
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end
end
