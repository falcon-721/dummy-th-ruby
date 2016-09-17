require 'acceptance_helper'

feature 'user sign in', js: true do
  given(:user) { create(:user) }

  scenario 'registered user signs in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'non-registered user try to sing in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  xscenario 'show login form', :visual do
    visit new_user_session_path
    expect(page).to match_reference_screenshot
  end
end
