require_relative '../acceptance_helper'

feature 'Create Comment for Answer', %q{
  In order to create comment for A
  As an authenticated user
  I want to be able to create comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'try to add comment for Answer', js: true do
      within "##{dom_id answer}" do
        click_on 'Add comment'
        fill_in 'Body', with: 'My new comment'
        click_on 'Create comment'

        within '.comments-list' do
          expect(page).to have_content 'My new comment'
        end
      end
    end
  end

  describe 'non-authenticated user' do
    before do
      visit question_path question
    end
    scenario 'should not have Add comment link and form', js: true do
      within "##{dom_id answer} .comments-container" do
        expect(page).to_not have_link 'Add comment'
        expect(page).to_not have_selector '.comments-form form'
      end
    end
  end
end
