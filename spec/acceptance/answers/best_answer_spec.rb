require 'acceptance_helper'

feature 'choose best answer', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  shared_examples "cannot choose best answer" do
    scenario "cannot see Best link" do
      within "#answer_#{answer.id} .answer-controls" do
        expect(page).to have_no_link("Best answer")
      end
    end
  end

  context "as user" do
    context "as question author" do
      given!(:answer2) { create(:answer, question: question, best: true) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "best answer is first in the list", :aggregate_failures do
        within ".answers .answer:first-child" do
          expect(page).to have_content(answer2.body)
          expect(page).to have_content('best')
        end
      end

      scenario "chooses best answer", :aggregate_failures do
        within "#answer_#{answer.id} .answer-controls" do
          click_on "Best answer"
        end

        expect(page).to have_content "You have successfully chosen the best answer"

        within ".answers .answer:first-child" do
          expect(page).to have_content(answer.body)
          expect(page).to have_content('best')
        end

        within ".answers .answer:last-child" do
          expect(page).to have_content(answer2.body)
          expect(page).to have_no_content('best')
        end
      end
    end

    context "not question author" do
      given(:question) { create(:question) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      it_behaves_like "cannot choose best answer"
    end
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot choose best answer"
  end
end
