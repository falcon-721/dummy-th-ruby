require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  before do
    @voted_to = create(model.to_s.underscore.to_sym)
  end

  it 'has a #vote_sum' do
    expect(@voted_to.votes_sum).to eq 0
  end

  describe 'has a #user_is_voted?' do
    context 'when user is voted before' do
      it 'does return true' do
        vote = create(:vote, voteable: @voted_to, user: user, value: 1)
        expect(@voted_to.user_is_voted? user).to be true
      end

      it 'does return false' do
        expect(@voted_to.user_is_voted? user).to be false
      end
    end
  end

  describe 'has a #re_vote' do
    it 'does destroy vote for Voteable' do
      vote = create(:vote, voteable: @voted_to, user: user, value: 1)
      @voted_to.re_vote user
      expect(@voted_to.user_is_voted? user).to be false
    end
  end
end
