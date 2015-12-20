module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def votes_sum
    votes.sum(:value)
  end

  def user_is_voted?(user)
    votes.where(user: user).exists?
  end

  def re_vote(user)
    vote = votes.find_by(user: user)
    if vote
      vote.destroy
      return true
    end
    false
  end

  def make_vote(value, user)
    user_vote = votes.find_or_initialize_by(user: user)
    user_vote.value = value
    user_vote.save
  end
end
