require 'rails_helper'

describe CommentsController, :auth do

  shared_examples "comments #create" do |context_name|
    context context_name do
      it "change comments count" do
        expect { subject }.to change(context.comments, :count).by(1)
      end

      it_behaves_like "invalid params", "empty body", model: Comment do
        let(:form_params) { { body: '' } }
      end
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    let(:form_params) { {} }

    let(:params) do
      { comment: attributes_for(:comment).merge(form_params), format: :js }.merge(context_params)
    end

    subject { post :create, params }

    it_behaves_like "comments #create", "question" do
      let(:context_params) { { question_id: question, context: 'question' } }
      let(:context) { question }
    end

    it_behaves_like "comments #create", "answer" do
      let(:context_params) { { answer_id: answer, context: 'answer' } }
      let(:context) { answer }
    end
  end
end
