class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    gon.current_user_id = current_user.id if current_user
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      PrivatePub.publish_to(
        "/questions",
        question: render_to_string(partial: 'question', locals: { question: @question })
      )
      redirect_to question_path @question
    else
      render :new
    end
  end

  def destroy
    if @question.user_id == current_user.id
      flash[:notice] = 'Your question deleted.'
      @question.destroy
    else
      flash[:alert] = 'You can not delete this question.'
    end
    redirect_to questions_path
  end

  def update
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
