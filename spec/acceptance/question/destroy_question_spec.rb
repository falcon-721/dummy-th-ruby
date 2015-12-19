require_relative '../acceptance_helper'

feature 'Destroy Question', %q{
  In order to destroy  question
  For Question Owner
  I want to destroy question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }

  scenario 'Signed in User(owner) can destroy question' do
    sign_in user
    visit question_path question

    click_on 'Delete question'
    expect(page).to have_content 'Your question deleted.'
  end

  scenario 'Non-sign in user dont have delete question link' do
    visit question_path question
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Not owner dont have delete question link' do
    sign_in user
    visit question_path another_question
    expect(page).to_not have_link 'Delete question'
  end
end