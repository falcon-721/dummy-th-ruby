require 'acceptance_helper'
require "bg_helper" unless Nenv.skip_bg?

feature 'create question', :js do
  given(:user) { create(:user) }

  context "as user" do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'creates qustion with valid params', :aggregate_failures do
      page.find("#add_question_btn").trigger('click')

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test text'
      click_on 'Save'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test text'
    end

    scenario 'can not create question with invalid params' do
      page.find("#add_question_btn").trigger('click')

      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Save'

      expect(page).to have_content 'Title can\'t be blank '
      expect(page).to have_content 'Body can\'t be blank '
    end
  end

  context "as guest" do
    scenario 'can not create question', :visual do
      visit questions_path
      expect(page).to match_reference_screenshot
    end
  end

  context "multiple sessions", :faye_normal do
    scenario "all users see new question in real-time" do
      Capybara.using_session('author') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('author') do
        page.find("#add_question_btn").trigger('click')

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Save'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to_not have_content 'No questions found('
      end
    end
  end
end
