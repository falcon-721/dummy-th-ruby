module VotedController
  module VotedAction
    def test_creates_vote
      assert_difference -> { @votable.votes.count }, 1 do
        post polymorphic_path(@votable, action: @action, format: :json), xhr: true
      end
    end

    def test_changes_rating
       assert_difference -> { @votable.votes_sum }, @delta do
        post polymorphic_path(@votable, action: @action, format: :json), xhr: true
      end
    end

    def test_respond_with_json
      post polymorphic_path(@votable, action: @action, format: :json), xhr: true
      json = JSON.parse(@response.body)
      assert_equal @votable.id, json.fetch('votable_id')
    end

    def test_do_no_vote_twice
      create(:vote, votable: @votable, user: @user)

      assert_no_difference 'Vote.count' do
        post polymorphic_path(@votable, action: @action, format: :json), xhr: true
      end
    end

    def test_do_no_vote_myself
      sign_out(@user)
      sign_in(@votable.user)

      assert_no_difference 'Vote.count' do
        post polymorphic_path(@votable, action: @action, format: :json), xhr: true
      end

      assert_response :forbidden
    end
  end

  module VoteUp
    def setup
      super
      @action = :vote_up
      @delta = 1
    end

    include VotedAction
  end

  module VoteDown
    def setup
      super
      @action = :vote_down
      @delta = -1
    end

    include VotedAction
  end

  module CancelVote
    def test_cancel_vote
      create(:vote, votable: @votable, user: @user)
      assert_difference 'Vote.count', -1 do
        post polymorphic_path(@votable, action: :cancel_vote, format: :json), xhr: true
      end
    end
  end
end
