require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to create answer with attached files
  As an authenticated user
  I want to be able to add files to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path question
  end

  scenario 'User can attach files for answer', js: true do
    fill_in 'Answer body', with: 'test text'
    attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
    end
  end

  scenario 'User can attach multiple files for answer', js: true do
    within '.answers' do
      fill_in 'Answer body', with: 'test text'
      all('.new_answer input[type="file"]')[0].set("#{Rails.root}/spec/rails_helper.rb")
      find("a.add_fields").click
      all('.new_answer input[type="file"]')[1].set("#{Rails.root}/spec/spec_helper.rb")
      click_on 'Create'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

end
