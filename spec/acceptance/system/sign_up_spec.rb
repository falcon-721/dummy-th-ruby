require 'acceptance_helper'

feature 'user sign up', js: true do
  given(:user_params) { attributes_for(:user) }

  scenario 'registers with valid data' do
    visit new_user_registration_path
    fill_in 'Email', with: user_params[:email]
    fill_in 'Password', with: user_params[:password]
    fill_in 'Password confirmation', with: user_params[:password]
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'registers with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'not_a_email'
    fill_in 'Password', with: '123123123'
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content 'Email is invalid'
    expect(current_path).to eq user_registration_path
  end
end
