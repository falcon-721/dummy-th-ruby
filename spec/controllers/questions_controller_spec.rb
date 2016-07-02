require 'rails_helper'

describe QuestionsController, :auth do
  let(:question) { create(:question, user: user) }

  describe "GET #show", :unauth do
    render_views

    specify do
      get :show, id: question
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    let(:form_params) { {} }
    let(:params) { { question: attributes_for(:question).merge(form_params) } }
    subject { post :create, params }

    it "creates new question" do
      expect { subject }.to change(user.questions, :count).by(1)
    end

    it 'transmits message' do
      expect { subject }.to transmit_to('/questions')
    end

    it_behaves_like "invalid params", "empty title", model: Question do
      let(:form_params) { { title: '' } }
    end

    it_behaves_like "invalid params", "empty body", model: Question do
      let(:form_params) { { body: '' } }
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    subject { delete :destroy, id: question }

    it "destroys question" do
      expect { subject }.to change(Question, :count).by(-1)
    end

    it_behaves_like "invalid params", "non-owner", model: Question, code: 302 do
      let!(:question) { create(:question) }
    end
  end

  describe 'PATCH #update' do
    let(:form_params) { { title: 'Edited title', body: 'Edited body' } }
    let(:params) { { id: question, question: form_params } }
    subject { patch :update, params }

    it 'changes title and body', :aggregate_failures do
      subject
      question.reload
      expect(question.title).to eq 'Edited title'
      expect(question.body).to eq 'Edited body'
    end
  end

  it_behaves_like "voted", :question
end
