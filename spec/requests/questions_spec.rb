require 'rails_helper'

describe QuestionsController, :auth do
  let(:question) { create(:question, user: user) }

  describe "GET #show", :unauth do
    specify do
      get "/questions/#{question.id}"
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    let(:form_params) { {} }
    let(:params) { { question: attributes_for(:question).merge(form_params) } }
    let(:request) { post "/questions", params: params }

    it "creates new question" do
      expect { subject }.to change(user.questions, :count).by(1)
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

    let(:request) { delete "/questions/#{question.id}" }

    it "destroys question" do
      expect { subject }.to change(Question, :count).by(-1)
    end

    it_behaves_like "invalid params", "non-owner", model: Question, code: 302 do
      let!(:question) { create(:question) }
    end
  end

  describe 'PATCH #update' do
    let(:form_params) { { title: 'Edited title', body: 'Edited body' } }
    let(:params) { { question: form_params } }
    let(:request) { patch "/questions/#{question.id}", params: params }

    it 'changes title and body', :aggregate_failures do
      subject
      question.reload
      expect(question.title).to eq 'Edited title'
      expect(question.body).to eq 'Edited body'
    end
  end

  it_behaves_like "voted_requests", "question"
end
