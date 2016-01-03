module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def votes_sum
    votes.sum(:value)
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def cancel_vote(user)
    vote = votes.find_by(user: user)
    return false unless vote
    vote.destroy
    true
  end

  def vote!(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.value = value
    vote.save
  end
end
