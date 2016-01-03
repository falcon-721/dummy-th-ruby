require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe "#vote_sum" do
    it "equals to zero" do
      expect(votable.votes_sum).to eq 0
    end

    it "equals to sum of votes" do
      create(:vote, votable: votable, value: 2)
      expect(votable.votes_sum).to eq 2
    end
  end

  describe "#vote!" do
    it "creates new vote" do
      expect { votable.vote!(user, 1) }
        .to change(votable.votes, :count).by(1)
    end
  end

  describe "#cancel_vote" do
    it "removes vote" do
      create(:vote, user: user, votable: votable)
      expect { votable.cancel_vote(user) }
        .to change(Vote, :count).by(-1)
    end
  end
end
