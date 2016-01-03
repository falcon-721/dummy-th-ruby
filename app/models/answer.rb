class Answer < ActiveRecord::Base
  include Voteable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      # self.best = true
      update!(best: true)
    end
  end
end
