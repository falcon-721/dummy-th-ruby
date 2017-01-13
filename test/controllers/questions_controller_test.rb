require 'test_helper'

require_relative './shared/voted_controller'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  class ShowQuestionTest < self
    test "show quesion" do
      question = create(:question)

      get question_url(question)
      assert_response :success
    end
  end

  class AuthTest < self
    def setup
      @user = create(:user)
      sign_in @user
    end
  end

  class CreateQuestionTest < AuthTest
    test "creates new question" do
      assert_difference -> { @user.questions.count }, 1 do
        post questions_path, params: { question: attributes_for(:question) }
      end
    end

    test "invalid_when_empty_title" do
      assert_no_difference 'Question.count' do
        post questions_path, params: { question: attributes_for(:question, title: '') }
      end
      assert_response :forbidden
    end

    test "invalid_when_empty_body" do
      assert_no_difference 'Question.count' do
        post questions_path, params: { question: attributes_for(:question, body: '') }
      end
      assert_response :forbidden
    end
  end

  class DeleteQuestionTest < AuthTest
    test "destroys question" do
      question = create(:question, user: @user)
      assert_difference 'Question.count' , -1 do
        delete question_path(question)
      end
    end

    test "non-owner cannot destroy" do
      question = create(:question)
      assert_no_difference 'Question.count' do
        delete question_path(question)
      end

      assert_redirected_to root_path
    end
  end

  class UpdateQuestionTest < AuthTest
    test "update question" do
      question = create(:question, user: @user)
      patch question_path(question), params: { question: { title: 'Edited title', body: 'Edited body' } }

      question.reload
      assert_equal 'Edited title', question.title
      assert_equal 'Edited body', question.body
    end
  end

  class Voted < AuthTest
    def setup
      @votable = create(:question)
      super
    end

    class VoteUpAnswer < self
      include VotedController::VoteUp
    end

    class VoteDownAnswer < self
      include VotedController::VoteDown
    end

    class CancelVoteAnswer < self
      include VotedController::CancelVote
    end
  end
end
