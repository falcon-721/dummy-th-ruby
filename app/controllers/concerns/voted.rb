module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    @votable.vote!(current_user, 1)
    render 'shared/votes'
  end

  def vote_down
    @votable.vote!(current_user, -1)
    render 'shared/votes'
  end

  def cancel_vote
    if @votable.cancel_vote(current_user)
      render 'shared/votes'
    else
      render status: :forbidden
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
    authorize @votable
  end
end
