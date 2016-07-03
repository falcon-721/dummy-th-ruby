require 'acceptance_helper'

feature "edit answer", :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples "cannot edit answer" do
    scenario "cannot see edit link" do
      within "#answer_#{answer.id} .answer-controls" do
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
        within "#answer_#{answer.id} .answer-controls" do
          click_on 'Edit'
        end
      end

      scenario "updates answer", :aggregate_failures do
        within "#answer_#{answer.id} .answer-edit-form" do
          fill_in 'Body', with: 'Edited body'
          click_on 'Save'
        end

        expect(page).to have_content "Your answer has been successfully updated"

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'Edited body'
      end

      scenario "invalid params" do
        within "#answer_#{answer.id} .answer-edit-form" do
          fill_in 'Body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content 'Body can\'t be blank'
      end

      context "markup", :visual do
        given(:question) { create(:question, title: 'My question', body: 'What are you waiting for?') }
        given!(:answer) { create(:answer, body: 'For the sun', question: question, user: user) }

        scenario "edit form" do
          wait_animation
          expect(page).to match_reference_screenshot
        end
      end
    end

    context "non-owner" do
      given(:answer) { create(:answer, question: question) }

      it_behaves_like "cannot edit answer"
    end
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot edit answer"
  end
end
