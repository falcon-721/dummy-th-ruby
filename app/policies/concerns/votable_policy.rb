module VotablePolicy
  extend ActiveSupport::Concern

  included do
    alias_all :vote_up?, :vote_down?, to: :vote?
  end

  def cancel_vote?
    user?
  end

  def vote?
    user? && !author?
  end
end
