class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_commentable, only: [:create]

  def show
    @comment = Comment.find(params[:id])
    render partial: 'comment', locals: { comment: @comment }, layout: false
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      PrivatePub.publish_to(
        publish_channel(@commentable),
        post: (
          @comment.attributes.merge(
            type: 'new_comment',
            commentable_type: @commentable.class.name,
            commentable_id: @commentable.id,
            _html: render_to_string(partial: 'comment', locals: { comment: @comment })
          )).to_json)
      render nothing: true
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable_class
    params[:comment][:commentable].classify.constantize
  end

  def commentable_id
    case params[:comment][:commentable]
    when 'Question'
      params[:question_id]

    when 'Answer'
      params[:answer_id]
    end
  end

  def publish_channel(commentable)
    case commentable
    when Question
      "/questions/#{commentable.id}/answers"

    when Answer
      "/questions/#{commentable.question.id}/answers"
    end
  end

  def load_commentable
    @commentable = commentable_class.find(commentable_id)
  end
end
