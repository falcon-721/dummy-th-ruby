class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :best_answers, -> { where(best: true) },
    class_name: "Answer"

  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
