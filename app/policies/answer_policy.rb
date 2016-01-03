class AnswerPolicy < ApplicationPolicy
  include VotablePolicy

  def best?
    user? && author?(target.question)
  end
end
