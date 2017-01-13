require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    sign_in @user
  end

  module SharedCreateComment
    def test_create_comment
      assert_difference -> { @commentable.comments.count }, 1 do
        post polymorphic_path([@commentable, :comments]), params: { comment: attributes_for(:comment) }, xhr: true
      end
    end

    def test_invalid_without_body
      assert_no_difference 'Comment.count' do
        post polymorphic_path([@commentable, :comments]), params: { comment: attributes_for(:comment, body: '') }, xhr: true
      end

      assert_response :forbidden
    end
  end

  class QuestionComments < self
    def setup
      @commentable = create(:question)
      super
    end

    include SharedCreateComment
  end

  class AnswerComments < self
    def setup
      @commentable = create(:answer)
      super
    end

    include SharedCreateComment
  end
end
