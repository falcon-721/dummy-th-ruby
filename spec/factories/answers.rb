FactoryGirl.define do
  factory :answer do
    question
    body { Faker::Lorem.sentence }
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end
end
