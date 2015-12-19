class AnswersController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create, :show]
  before_action :set_answer, only: [:destroy, :update, :best, :show]

  def show
    render partial: @answer, locals: { answer: @answer }
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    if @answer.valid?
      PrivatePub.publish_to(
        "/questions/#{@question.id}/answers",
        post:
          { type: 'new_answer',
            _html: render_to_string(partial: 'answer', locals: { answer: @answer }) }.to_json
      )
      render nothing: true
    end
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def best
    @question = @answer.question
    @answer.make_best if @question.user_id == current_user.id
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
