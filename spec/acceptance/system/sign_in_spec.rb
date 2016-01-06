require 'acceptance_helper'

feature 'User sign in', js: true do
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

  scenario 'show login form', :visual do
    visit new_user_session_path
    expect(page).to match_expectation
  end
end
