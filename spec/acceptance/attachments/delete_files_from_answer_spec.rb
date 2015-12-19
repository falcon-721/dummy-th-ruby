require_relative '../acceptance_helper'

feature 'Delete files to answer', %q{
  In order to edit answer with attached files
  As an authenticated user
  I want to be able to delete files to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer_with_files, user: user, question: question) }

  background do
    sign_in user
    visit question_path question
  end

  scenario 'User can delete files for answer', js: true do
    within '.answers' do
      click_on 'Edit'
      within '.edit-answer-form' do
        fill_in 'Answer', with: 'Update'
        all(:link, 'remove file')[0].click
        click_on 'Save'
      end
      expect(page).to_not have_link 'rails_helper.rb'
    end
      
  end
end