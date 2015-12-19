require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to create question with attached files
  As an authenticated user
  I want to be able to add files to question
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User can attach files for question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test text'
    attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    within '.question' do
      expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
    end
  end

  scenario 'User can attach multiple files for question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test text'
    all('.new_question input[type="file"]')[0].set("#{Rails.root}/spec/rails_helper.rb")
    find("a.add_fields").click
    all('.new_question input[type="file"]')[1].set("#{Rails.root}/spec/spec_helper.rb")
    click_on 'Create'

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end