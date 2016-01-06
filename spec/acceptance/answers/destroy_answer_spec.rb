require 'acceptance_helper'

feature 'Destroy Answer', %q{
  In order to destroy answer
  For Answer Owner
  I want to destroy answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: create(:user), question: question) }

  context 'Author' do
    before do
      answer
      sign_in user
      visit question_path question
    end

    scenario 'can destroy answer', js: true do
      click_on 'Delete answer'
      expect(page).to have_content 'Your answer deleted.'
    end

    scenario 'deleted answer should remove from page', js: true do
      click_on 'Delete answer'
      expect(page).to_not have_selector ("div#answer-id-#{answer.id}")
    end
  end

  scenario 'non-sign in user dont have delte link' do
    answer
    visit question_path question
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Not owner dont have delte link' do
    another_answer
    sign_in user
    visit question_path question
    expect(page).to_not have_link 'Delete answer'
  end
end
