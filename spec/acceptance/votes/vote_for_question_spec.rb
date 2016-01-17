require 'acceptance_helper'

feature 'votes for question', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  it_behaves_like "votes features" do
    given(:votable_selector) { ".question-info" }
    given(:votable) { question }
  end
end
