module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    @votable.vote!(current_user, 1)
    render_votable
  end

  def vote_down
    @votable.vote!(current_user, -1)
    render_votable
  end

  def cancel_vote
    if @votable.cancel_vote(current_user)
      render_votable
    else
      render status: :forbidden
    end
  end

  private

  def render_votable
    render json: {
      total: @votable.votes_sum,
      is_voted: @votable.voted_by?(current_user),
      votable_id: @votable.id,
      votable_type: @votable.class.name
    }
  end

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
    authorize @votable
  end
end
