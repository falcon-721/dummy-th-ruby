module VotablePolicy
  extend ActiveSupport::Concern

  included do
    alias_all :vote_up?, :vote_down?, to: :vote?
  end

  def cancel_vote?
    user? && target.votes.where(user_id: user.id).exists?
  end

  protected

  def vote?
    user? && !author?
  end
end
