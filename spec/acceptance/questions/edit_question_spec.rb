require 'acceptance_helper'

feature 'Edit Question', %q{
  In order to edit  question
  For Question Author
  I want to edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  describe 'Author' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'have edit link' do
      expect(page).to have_link 'Edit'
    end

    scenario 'can edit question', js: true do
      click_on 'Edit'
      within '#edit-question-form-container' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Save'
      end
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body

      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited body'
    end
  end

  scenario 'Not an author dont have edit link' do
    sign_in another_user
    visit question_path question
    expect(page).to_not have_link 'Edit'
  end

  scenario 'Non-authed user dont have edit link' do
    visit question_path question
    expect(page).to_not have_link 'Edit'
  end
end
