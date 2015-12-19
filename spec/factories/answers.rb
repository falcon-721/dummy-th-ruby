FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n}"
  end

  factory :answer do
    question
    body
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end

  factory :answer_with_files, class: 'Answer' do
    body
    after(:create) do |answer|
      answer.attachments.create(attributes_for(:attachment))
    end
  end
end
