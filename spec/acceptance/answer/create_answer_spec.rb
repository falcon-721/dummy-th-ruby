require_relative '../acceptance_helper'

feature 'Create Answer for Question', %q{
  In order to create Answer for Question
  For Signed in User
  i want to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Signed in user try to create answer', js: true do
    sign_in user
    visit question_path question

    fill_in 'Answer body', with: 'My Answer'
    click_on 'Create Answer'
    within 'div.answers' do
      expect(page).to have_content 'My Answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Signed in user try to create answer with invalid params', js: true do
    sign_in user
    visit question_path question

    fill_in 'Answer body', with: ''
    click_on 'Create Answer'
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'non-authorized user dont have Create Answer form' do
    visit question_path question
    expect(page).to_not have_selector('form#new_answer')
    expect(page).to_not have_selector('input[type=submit][value=\'Create Answer\']')
  end
end
