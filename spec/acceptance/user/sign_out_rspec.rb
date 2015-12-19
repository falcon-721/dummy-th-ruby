require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to close session
  As an Signed in User
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Signed in user try to sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end