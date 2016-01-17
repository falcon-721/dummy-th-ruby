require 'acceptance_helper'

feature 'destroy question', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  shared_examples "cannot destroy question" do
    scenario "cannot see delete button" do
      within ".question-controls" do
        expect(page).to have_no_link("Delete")
      end
    end
  end

  context "as user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "destroys question", :aggregate_failures do
      within ".question-controls" do
        click_on 'Delete'
      end
      expect(page).to have_content "Your question has been successfully removed"
      expect(current_path).to eq questions_path
      expect(page).to have_no_content(question.title)
    end

    context "non-owner" do
      given(:question) { create(:question) }

      it_behaves_like "cannot destroy question"
    end
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot destroy question"
  end
end
