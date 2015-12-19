require_relative '../acceptance_helper'

feature 'Add new files to answer', %q{
  In order to edit answer with attached files
  As an authenticated user
  I want to be able to new add files to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_files, user: user) }


  background do
    sign_in user
    visit question_path question
  end

  scenario 'User can attach new files for question', js: true do
    within '.question' do
      click_on 'Edit'
      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
      click_on 'Save'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end