require_relative '../acceptance_helper'

feature 'Questions index', %q{
  In order to be able to see questions list
  As an User
  I want to be able to see questions list
} do

  given!(:questions) { create_list(:question, 2) }
  given(:user) { create(:user) }


  scenario 'without sign in' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    expect(page).to have_content questions.first.title
  end

  scenario 'with sign in' do
    sign_in user
    visit questions_path

    expect(page).to have_content 'Questions list'
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end