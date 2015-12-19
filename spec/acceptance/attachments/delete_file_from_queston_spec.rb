require_relative '../acceptance_helper'

feature 'Delete files to question', %q{
  In order to edit question with attached files
  As an authenticated user
  I want to be able to delete files to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_files, user: user) }


  background do
    sign_in user
    visit question_path question
  end

  scenario 'User can delete files for question', js: true do
    within '.question' do
      click_on 'Edit'
      all(:link, 'remove file')[0].click
      click_on 'Save'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end
end