require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe "POST #create" do
    before { sign_in(user) }

    context "with valid params" do
      it "create new question" do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(user.questions, :count).by(1)
      end

      it 'have right question owner' do
        expect{
          post :create, question: attributes_for(:question)
        }.to change(user.questions, :count).by(1)
      end
    end

    context "with invalid params" do
      it 'not create new question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:another_question) { create(:question) }

    context 'signed in question owner' do
      before { sign_in(user) }

      let!(:question) { create(:question, user: user) }

      context 'question owner' do
        it 'destroy question' do
          expect { delete :destroy, id: question }.to change(user.questions, :count).by(-1)
        end
      end

      context 'Not question owner' do
        it 'not destroy question' do
          expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
        end
      end
    end

    context 'Non-signed in user' do
     it 'not destroy question' do
       expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
     end
    end
  end

  describe 'PATCH #update' do
    context 'Non-signed user' do
      it 'not change question' do
        expect {
          patch :update, id: question, question: attributes_for(:question), format: :js
        }.to_not change{question}
      end
    end

    context 'Signed in user' do
      before { sign_in user }

      context 'with valid attrs' do
        it 'change title' do
          patch :update, id: question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          question.reload
          expect(question.title).to eq 'Edited title'
        end
        it 'change body' do
          patch :update, id: question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          question.reload
          expect(question.body).to eq 'Edited body'
        end
      end

      context 'with invalid params' do
        it 'not change title' do
          expect {
            patch :update, id: question, question: { title: '', body: 'Edited body' }, format: :js
          }.to_not change(question, :title)
        end
        it 'not change body' do
          expect {
            patch :update, id: question, question: { title: 'Edited title', body: '' }, format: :js
          }.to_not change(question, :body)
        end
      end
    end
  end

  describe 'POST #vote_plus' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    before { sign_in user }
    context 'not qusetion autor can vote for Question' do
      it 'change Votes count' do
        expect {
          post :vote_plus, id: another_question
        }.to change(another_question.votes, :count).by(1)
      end

      it 'have votes sum' do
        post :vote_plus, id: another_question
        expect(another_question.votes_sum).to eq 1
      end

      context 'double vote' do
        before { post :vote_plus, id: another_question }
        it 'not change Votes count' do
          expect {
            post :vote_plus, id: another_question
          }.to_not change(another_question.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote_for_question, user: user, voteable: another_question, value: -1) }
        it 'not change Votes count' do
          expect {
            post :vote_plus, id: another_question
          }.to_not change(another_question.votes, :count)
        end

        it 'change vote.value' do
          post :vote_plus, id: another_question
          vote.reload
          expect(vote.value).to eq 1
        end
      end
    end

    context 'question author can not vote for Question' do
      it 'not change Votes count' do
        expect {
          post :vote_plus, id: question
        }.to_not change(Vote, :count)
      end

      it 'have votes sum' do
        post :vote_plus, id: question
        expect(another_question.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #vote_minus' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    before { sign_in user }
    context 'not question autor can vote for Question' do
      it 'change Votes count' do
        expect {
          post :vote_minus, id: another_question
        }.to change(another_question.votes, :count).by(1)
      end

      it 'have votes sum' do
        post :vote_minus, id: another_question
        expect(another_question.votes_sum).to eq -1
      end

      context 'double vote' do
        before { post :vote_minus, id: another_question }
        it 'not change Votes count' do
          expect {
            post :vote_minus, id: another_question
          }.to_not change(another_question.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote_for_question, user: user, voteable: another_question, value: 1) }
        it 'not change Votes count' do
          expect {
            post :vote_minus, id: another_question
          }.to_not change(another_question.votes, :count)
        end

        it 'change vote.value' do
          post :vote_minus, id: another_question
          vote.reload
          expect(vote.value).to eq -1
        end
      end
    end

    context 'question author can not vote for Question' do
      it 'not change Votes count' do
        expect {
          post :vote_minus, id: question
        }.to_not change(Vote, :count)
      end

      it 'have votes sum' do
        post :vote_minus, id: question
        expect(another_question.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #re_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, voteable: question, user: user, value: 1) }

    before { sign_in user }

    context 're-vote' do
      it 'destroy vote for user' do
        expect {
          post :re_vote, id: question
        }.to change(Vote, :count).by(-1)
      end
    end
  end
end
