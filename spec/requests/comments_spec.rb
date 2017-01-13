require 'rails_helper'

describe CommentsController, :auth do
  shared_examples "comments #create requests" do |context_name|
    context context_name do
      let(:request) { post "/#{context_name.pluralize}/#{context.id}/comments", params: params }

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
      { comment: attributes_for(:comment).merge(form_params) }
    end

    it_behaves_like "comments #create requests", "question" do
      let(:context) { question }
    end

    it_behaves_like "comments #create requests", "answer" do
      let(:context) { answer }
    end
  end
end
