shared_examples "votes features" do
  context "as user" do
    context "non author" do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "sees total votes and links", :aggregate_failures do
        within "#{votable_selector} .votes" do
          expect(page).to have_content '0'
          expect(page).to have_link 'thumb_up'
          expect(page).to have_link 'thumb_down'
        end
      end

      scenario "votes up", :aggregate_failures do
        within "#{votable_selector} .votes" do
          click_on 'thumb_up'
          expect(page).to have_content '1'
          expect(page).to have_no_link 'thumb_up'
          expect(page).to have_no_link 'thumb_down'
          expect(page).to have_link 'Cancel'
        end
      end

      scenario "votes down", :aggregate_failures do
        within "#{votable_selector} .votes" do
          click_on 'thumb_down'
          expect(page).to have_content '-1'
          expect(page).to have_no_link 'thumb_up'
          expect(page).to have_no_link 'thumb_down'
          expect(page).to have_link 'Cancel'
        end
      end
    end

    context "voter" do
      given!(:vote) { create(:vote, votable: votable, user: user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "cancels vote", :aggregate_failures do
        within "#{votable_selector} .votes" do
          click_on 'Cancel'
          expect(page).to have_content '0'
          expect(page).to have_link 'thumb_up'
          expect(page).to have_link 'thumb_down'
          expect(page).to have_no_link 'Cancel'
        end
      end
    end
  end

  context "as author" do
    background do
      sign_in(votable.user)
      visit question_path(question)
    end

    it_behaves_like "cannot vote for"
  end

  context "as guest" do
    background { visit question_path(question) }

    it_behaves_like "cannot vote for"
  end
end

shared_examples "cannot vote for" do
  scenario "sees no links", :aggregate_failures do
    within "#{votable_selector} .votes" do
      expect(page).to have_content '0'
      expect(page).to have_no_link 'thumb_up'
      expect(page).to have_no_link 'thumb_down'
      expect(page).to have_no_link 'Cancel'
    end
  end
end
