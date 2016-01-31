require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

  describe "POST #create" do
    before { sign_in(user) }

    context "with valid params" do
      it 'create answer for question' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'create answer for user' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'do not create answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'signed in user' do
      before { sign_in(user) }

      it 'delete answer' do
        expect {
          delete :destroy, id: answer, format: :js
        }.to change(Answer, :count).by(-1)
      end
    end

    context 'non-signed in user' do
      it 'not delete answer' do
        expect {
          delete :destroy, id: answer, format: :js
        }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    let(:answer) { create(:answer, user: user, question: question) }

    it 'change answer' do
      patch :update, id: answer, answer: { body: 'updated body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'updated body'
    end
  end

  describe 'POST #best' do
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    context 'Question author' do
      before { sign_in user }

      it 'change best status' do
        post :best, id: answer, format: :js
        answer.reload
        expect(answer.best).to be true
      end

      context 'with answers list' do
        let!(:answer_1) { create(:answer, question: question) }
        let!(:answer_2) { create(:answer, question: question) }

        it 'change best attr for answer_1', :aggregate_failures do
          post :best, id: answer_1, format: :js
          expect(answer_1.reload.best).to be true
          expect(question.answers.first).to eq answer_1
        end
      end
    end

    context 'Not question author' do
      before { sign_in john }
      it 'not change best attr' do
        post :best, id: answer, format: :js
        answer.reload
        expect(answer.best).to_not be true
      end
    end
  end

  describe 'POST #vote_up' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question) }

    before { sign_in user }
    context 'not answer autor can vote for Answer' do
      it 'change Votes count' do
        expect {
          post :vote_up, id: another_answer
        }.to change(another_answer.votes, :count).by(1)
      end

      it 'have votes sum' do
        post :vote_up, id: another_answer
        expect(another_answer.votes_sum).to eq 1
      end

      context 'double vote' do
        before { post :vote_up, id: another_answer }
        it 'not change Votes count' do
          expect {
            post :vote_up, id: another_answer
          }.to_not change(another_answer.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote, user: user, votable: another_answer, value: -1) }
        it 'not change Votes count' do
          expect {
            post :vote_up, id: another_answer
          }.to_not change(another_answer.votes, :count)
        end

        it 'change vote.value' do
          post :vote_up, id: another_answer
          vote.reload
          expect(vote.value).to eq 1
        end
      end
    end

    context 'answer author can not vote for Answer' do
      it 'not change Votes count' do
        expect {
          post :vote_up, id: answer
        }.to_not change(Vote, :count)
      end

      it 'have votes sum' do
        post :vote_up, id: answer
        expect(another_answer.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #vote_down' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question) }

    before { sign_in user }
    context 'not answer autor can vote for Answer' do
      it 'change Votes count' do
        expect {
          post :vote_down, id: another_answer
        }.to change(another_answer.votes, :count).by(1)
      end

      it 'have votes sum' do
        post :vote_down, id: another_answer
        expect(another_answer.votes_sum).to eq(-1)
      end

      context 'double vote' do
        before { post :vote_down, id: another_answer }
        it 'not change Votes count' do
          expect {
            post :vote_down, id: another_answer
          }.to_not change(another_answer.votes, :count)
        end
      end

      it 'responds with JSON object' do
        post :vote_down, id: another_answer
        expect(response.body).to be_json_eql(another_answer.id).at_path('votable_id')
      end
    end

    context 'question author can not vote for Answer' do
      it 'not change Votes count' do
        expect {
          post :vote_down, id: answer
        }.to_not change(Vote, :count)
      end

      it 'have votes sum' do
        post :vote_down, id: answer
        expect(another_answer.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #cancel_vote' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:vote) { create(:vote, user: user, votable: answer, value: 1) }

    before { sign_in user }

    it 'destroy vote' do
      expect {
        post :cancel_vote, id: answer
      }.to change(Vote, :count).by(-1)
    end
  end
end
