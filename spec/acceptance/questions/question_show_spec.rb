require 'acceptance_helper'

feature 'question page with answers', :js do
  given!(:question) { create(:question) }
  given!(:answers) { create_pair(:answer, question: question) }

  scenario 'see question with answers' do
    visit question_path(question)

    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
