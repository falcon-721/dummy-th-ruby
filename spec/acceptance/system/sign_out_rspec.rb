require 'acceptance_helper'

feature 'User sign in', js: true do
  given(:user) { create(:user) }

  scenario 'Signed in user try to sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
