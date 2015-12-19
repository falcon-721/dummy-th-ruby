require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sing in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-Registered user try to sing in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'show login form', :visual, :js do
    visit new_user_session_path
    expect(page).to match_expectation
  end
end
