require_relative '../acceptance_helper'

feature 'Create Question', %q{
  In order to get answer form community
  As an authenticated user
  I want to be able to as questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user can create qustion with valid params' do
    sign_in user
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test text'
    click_on 'Create'
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Signed in user can not create question with invalid params' do
    sign_in user
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank '
    expect(page).to have_content 'Body can\'t be blank '
  end

  scenario 'Non-authenticated user can not create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end