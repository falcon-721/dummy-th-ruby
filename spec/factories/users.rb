FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}_#{ENV['TEST_ENV_NUMBER'] || ''}@test.com"}
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end
