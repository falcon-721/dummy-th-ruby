FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
