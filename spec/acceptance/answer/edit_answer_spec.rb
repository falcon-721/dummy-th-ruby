require_relative '../acceptance_helper'

feature 'Edit Answer for Question', %q{
  In order to Edit answer for Question
  For Answer Author
  i want to edit answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:another_user_answer) { create(:answer, question: question) }

  describe 'Author' do
    given!(:answer) { create(:answer, user: user, question: question) }
    before :each do
      sign_in user
      visit question_path question
    end

    scenario 'have edit link and form' do
      within('.answers') do
        expect(page).to have_link('Edit')
        click_on 'Edit'
        expect(page).to have_selector 'form.edit_answer textarea'
      end
    end

    scenario 'can edit his answer', js: true do
      click_on 'Edit'
      within 'form.edit_answer' do
        fill_in 'Answer', with: 'edited answer'
      end
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to have_selector 'textarea'
    end

    scenario 'with invalid attr should see errors', js: true do
      click_on 'Edit'
      within 'form.edit_answer' do
        fill_in 'Answer', with: ''
      end
      click_on 'Save'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Non-authorized user dont have edit link' do
    visit question_path question
    within('.answers') do
      expect(page).to_not have_link('Edit')
    end
  end

  scenario 'Not the author dont have edit link' do
    sign_in user
    visit question_path question

    expect(page).to_not have_link('Edit')
  end
end