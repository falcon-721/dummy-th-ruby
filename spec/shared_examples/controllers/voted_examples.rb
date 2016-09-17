shared_examples "voted" do |votable_type|
	let(:votable_type) { votable_type }
	let(:votable) { create(votable_type) }

	include_examples "voted: create vote", :vote_up, 1
	include_examples "voted: create vote", :vote_down, -1

  describe 'POST #cancel_vote' do
    let!(:vote) { create(:vote, user: user, votable: votable) }

    subject { post :cancel_vote, params: { id: votable } }

    it 'destroy vote' do
      expect { subject }.to change(Vote, :count).by(-1)
    end
  end
end

shared_examples "voted: create vote" do |action, delta|
	describe "POST ##{action}" do
    subject { post action, params: { id: votable, format: :json } }

    it "change Votes count" do
      expect { subject }.to change(votable.votes, :count).by(1)
    end

     it "change rating by #{delta}" do
      expect { subject }.to change(votable, :votes_sum).by(delta)
    end

    it 'responds with JSON object' do
      expect(subject.body).to be_json_eql(votable.id).at_path('votable_id')
    end

    it_behaves_like "invalid params", "already voted", model: Vote, code: nil do
      let!(:vote) { create(:vote, votable: votable, user: user) }
    end

    it_behaves_like "invalid params", "votable author", model: Vote do
       let(:votable) { create(votable_type, user: user) }
    end
  end
end