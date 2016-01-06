require 'acceptance_helper'

feature 'User sign up', js: true do
  given(:user_params) { attributes_for(:user) }

  scenario 'Registration with valid attributes' do
    visit new_user_registration_path
    fill_in 'Email', with: user_params[:email]
    fill_in 'Password', with: user_params[:password]
    fill_in 'Password confirmation', with: user_params[:password]
    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registration with invalid attributes' do
    visit new_user_registration_path
    fill_in 'Email', with: 'not_a_email'
    fill_in 'Password', with: '123123123'
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content 'Email is invalid'
    expect(current_path).to eq user_registration_path
  end
end
