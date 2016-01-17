require 'acceptance_helper'

feature 'votes for answer', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  it_behaves_like "votes features" do
    given(:votable_selector) { "#answer_#{answer.id}" }
    given(:votable) { answer }
  end
end
