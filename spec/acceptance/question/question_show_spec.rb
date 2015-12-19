require_relative '../acceptance_helper'

feature 'Show Question page with answers', %q{
  In order to Show Question page with answers
  For ALL users
  i want to see question show page
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'All user can see question with answers' do
    visit question_path(question)

    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end