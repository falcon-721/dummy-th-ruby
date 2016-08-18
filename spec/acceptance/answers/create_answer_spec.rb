require 'acceptance_helper'
require "bg_helper" unless Nenv.skip_bg?

feature "create answer", :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context "as user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "creates answer", :aggregate_failures do
      page.find("#add_answer_btn").trigger('click')

      within "#new_answer_form" do
        fill_in 'Body', with: 'test text'
        click_on 'Save'
      end

      expect(page).to have_content "Your answer has been successfully created"
      expect(page).to have_content "test text"
    end

    scenario "invalid answer data" do
      page.find("#add_answer_btn").trigger('click')

      within "#new_answer_form" do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  context "as guest" do
    given(:question) { create(:question, title: 'My question', body: 'What are you waiting for?') }

    background { visit question_path(question) }

    it "have no add button", :visual do
      expect(page).to match_reference_screenshot
    end
  end

  context "multiple sessions", :faye_normal do
    scenario "all users see new answer in real-time" do
      Capybara.using_session("author") do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("author") do
        page.find("#add_answer_btn").trigger('click')

        within "#new_answer_form" do
          fill_in 'Body', with: 'test text'
          click_on 'Save'
        end

        expect(page).to have_content "Your answer has been successfully created"
        expect(page).to have_content "test text"
      end

      Capybara.using_session("guest") do
        expect(page).to have_content "test text"
      end
    end
  end
end
