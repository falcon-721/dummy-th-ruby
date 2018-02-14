require 'rails_helper'

describe AnswersController, :auth do
  let(:question) { create(:question) }

  describe "POST /answers" do
    let(:form_params) { {} }

    let(:params) do
      {
        answer: attributes_for(:answer).merge(form_params)
      }
    end

    let(:request) { post "/questions/#{question.id}/answers.json", params: params }

    it 'create answer for question', :lurker do
      expect { subject }.to change(question.answers, :count).by(1)
    end

    it 'create answer for user' do
      expect { subject }.to change(user.answers, :count).by(1)
    end

    it_behaves_like "invalid params", "invalid answer", model: Answer do
      let(:form_params) { attributes_for(:invalid_answer) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    let(:request) { delete "/answers/#{answer.id}.json" }

    it 'delete answer', :lurker do
      expect { subject }.to change(Answer, :count).by(-1)
    end

    it_behaves_like "invalid params", "non-owner", model: Answer do
      let!(:answer) { create(:answer) }
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, user: user, question: question) }

    let(:form_params) { { body: 'updated body'} }
    let(:params) do
      { answer: form_params }
    end

    let(:request) { patch "/answers/#{answer.id}.json", params: params }

    it 'change answer', :lurker do
      subject
      answer.reload
      expect(answer.body).to eq 'updated body'
    end

    context "invalid body" do
      let(:form_params) { { body: '' } }

      it "doesn't update answer" do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe 'POST #best' do
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    subject { post "/answers/#{answer.id}/best.js" }

    it "change best status", :lurker do
      subject
      answer.reload
      expect(answer.best).to be true
    end

    context 'non-author' do
      let(:question) { create(:question, user: john) }

      it "doesn't change best" do
        subject
        answer.reload
        expect(answer.best).to_not be true
      end
    end
  end

  it_behaves_like "voted_requests", 'answer'
end
