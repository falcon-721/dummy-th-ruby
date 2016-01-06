require 'acceptance_helper'

feature 'questions index', :js do
  given!(:questions) { create_pair(:question) }
  given(:user) { create(:user) }

  scenario 'see list of questions' do
    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
