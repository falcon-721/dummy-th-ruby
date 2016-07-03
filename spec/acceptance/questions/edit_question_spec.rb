require 'acceptance_helper'

feature "edit question", :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  shared_examples "cannot edit question" do
    scenario "cannot see delete button" do
      within ".question-controls" do
        expect(page).to have_no_link("Edit")
      end
    end
  end

  context "as user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context "as author" do
      background do
        within ".question-controls" do
          click_on 'Edit'
        end
      end

      scenario "updates question", :aggregate_failures do
        within '#question_form' do
          fill_in 'Title', with: 'Edited title'
          fill_in 'Body', with: 'Edited body'
          click_on 'Save'
        end

        expect(page).to have_content "Your question has been successfully updated"

        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body

        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
      end

      scenario "invalid params" do
        within '#question_form' do
          fill_in 'Title', with: ''
          click_on 'Save'
        end

        expect(page).to have_content 'Title can\'t be blank'
      end

      context "markup", :visual do
        given(:question) { create(:question, title: 'My question', body: 'What are you waiting for?', user: user) }

        scenario "edit form" do
          wait_animation
          expect(page).to match_reference_screenshot
        end
      end
    end

    context "non-owner" do
      given(:question) { create(:question) }

      it_behaves_like "cannot edit question"
    end
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot edit question"
  end
end
