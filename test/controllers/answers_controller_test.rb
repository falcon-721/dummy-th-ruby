require 'test_helper'

require_relative './shared/voted_controller'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @question = create(:question, user: @user)
    sign_in @user
  end

  class CreateAnswerTest < self
    test "creates new answer for user" do
      assert_difference -> { @user.answers.count }, 1 do
        post question_answers_path(@question), params: { answer: attributes_for(:answer) }, xhr: true
      end
    end

    test "creates new answer for question" do
      assert_difference -> { @question.answers.count }, 1 do
        post question_answers_path(@question), params: { answer: attributes_for(:answer) }, xhr: true
      end
    end

    test "invalid_when_empty_body" do
      assert_no_difference 'Answer.count' do
        post question_answers_path(@question), params: { answer: attributes_for(:answer, body: '') }, xhr: true
      end
      assert_response :forbidden
    end
  end

  class DeleteAnswerTest < self
    test "destroys answer" do
      answer = create(:answer, user: @user, question: @question)
      assert_difference 'Answer.count' , -1 do
        delete answer_path(answer), xhr: true
      end
    end

    test "non-owner cannot destroy" do
      answer = create(:answer, question: @question)
      assert_no_difference 'Answer.count' do
        delete answer_path(answer), xhr: true
      end

      assert_response :forbidden
    end
  end

  class UpdateAnswerTest < self
    test "update answer" do
      answer = create(:answer, user: @user, question: @question)
      patch answer_path(answer), params: { answer: { body: 'Edited body' } }

      answer.reload
      assert_equal 'Edited body', answer.body
    end

    test "invalid when body is empty" do
      answer = create(:answer, user: @user, question: @question)
      patch answer_path(answer), params: { answer: { body: '' } }

      assert_response :forbidden
    end
  end

  class BestAnswerTest < self
    test "change best status" do
      answer = create(:answer, question: @question, user: @user)
      post best_answer_path(answer), xhr: true

      answer.reload
      assert answer.best
    end

    test "non-author cannot change best" do
      answer = create(:answer, user: @user)
      post best_answer_path(answer), xhr: true

      answer.reload
      assert_not answer.best
    end
  end

  class Voted < self
    def setup
      super
      @votable = create(:answer, question: @question)
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
