require 'rails_helper'

describe AnswersController, :auth do
  let(:question) { create(:question) }

  describe "POST #create" do
    let(:form_params) { {} }

    let(:params) do
      {
        question_id: question,
        answer: attributes_for(:answer).merge(form_params),
        format: :js 
      }
    end

    subject { post :create, params }

    it 'create answer for question' do
      expect { subject }.to change(question.answers, :count).by(1)
    end

    it 'create answer for user' do
      expect { subject }.to change(user.answers, :count).by(1)
    end

    it 'transmits message' do
      expect { subject }.to transmit_to("/questions/#{question.id}")
    end

    it_behaves_like "invalid params", "invalid answer", model: Answer do
      let(:form_params) { attributes_for(:invalid_answer) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    subject { delete :destroy, id: answer, format: :js }

    it 'delete answer' do
      expect { subject }.to change(Answer, :count).by(-1)
    end

    it_behaves_like "invalid params", "non-owner", model: Answer do
      let!(:answer) { create(:answer) }
    end

    it_behaves_like "unauthorized user request", "non-signed in user"
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, user: user, question: question) }

    let(:form_params) { { body: 'updated body'} }
    let(:params) do
      { id: answer, format: :js, answer: form_params }
    end

    subject { patch :update, params }

    it 'change answer' do
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

    subject { post :best, id: answer, format: :js }

    it "change best status" do
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

  it_behaves_like "voted", :answer
end
