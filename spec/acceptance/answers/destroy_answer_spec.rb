require 'acceptance_helper'

feature 'destroy answer', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  shared_examples "cannot destroy answer" do
    scenario "cannot see delete button" do
      within "#answer_#{answer.id} .answer-controls" do
        expect(page).to have_no_link("Delete")
      end
    end
  end

  context "as user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "destroys answer", :aggregate_failures do
      within "#answer_#{answer.id} .answer-controls" do
        click_on 'Delete'
      end
      expect(page).to have_content "Your answer has been successfully removed"
      expect(page).to have_no_content(answer.body)
    end

    context "non-owner" do
      given(:answer) { create(:answer, question: question) }

      it_behaves_like "cannot destroy answer"
    end
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot destroy answer"
  end
end
