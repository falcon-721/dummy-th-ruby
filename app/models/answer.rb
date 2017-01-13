class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc) }

  scope :best, -> { where(best: true) }

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
