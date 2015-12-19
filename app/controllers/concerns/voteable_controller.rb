module VoteableController
  extend ActiveSupport::Concern

  included do
    before_action :vote_for, only: [:vote_plus, :vote_minus, :re_vote]
  end

  def vote_plus
    vote(1)
  end

  def vote_minus
    vote(-1)
  end

  def re_vote
    res = @vote_for_obj.re_vote(current_user)
    if res
      render json: {
        success: res,
        votes_sum: @vote_for_obj.votes_sum,
        voted_to: @vote_for_obj.class.name,
        voted_to_id: @vote_for_obj.id,
        _html: render_to_string(partial: 'shared/votes', locals: { voted_to: @vote_for_obj })
      }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def vote(value)
    if current_user.id != @vote_for_obj.user_id
      @vote_for_obj.make_vote(value, current_user)
      render json: {
        votes_sum: @vote_for_obj.votes_sum,
        voted_to: @vote_for_obj.class.name,
        voted_to_id: @vote_for_obj.id,
        _html: render_to_string(partial: 'shared/votes', locals: { voted_to: @vote_for_obj })
      }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def vote_for
    @vote_for_obj = controller_name.classify.constantize.find(params[:id])
  end
end
