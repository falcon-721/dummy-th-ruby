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

  factory :question_with_files, class: 'Question' do
    title
    body "MyText"
    user
    after(:create) do |question|
      question.attachments.create(attributes_for(:attachment))
    end
  end
end
