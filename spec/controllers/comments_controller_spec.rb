require 'rails_helper'

describe CommentsController do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    before { sign_in user }

    context 'Comments for Question' do
      it 'change questions comment count' do
        expect {
          post :create, question_id: question, comment: attributes_for(:comment), context: 'question', format: :js
        }.to change(question.comments, :count).by(1)
      end
    end

    context 'Comments for Answer' do
      it 'change answers comments count' do
        expect {
          post :create, question_id: question, answer_id: answer, comment: attributes_for(:comment), context: 'answer', format: :js
        }.to change(answer.comments, :count).by(1)
      end
    end

    context 'Invalid comment' do
      it 'not create comment for question' do
        expect {
          post :create, question_id: question, comment: attributes_for(:invalid_comment), context: 'question', format: :js
        }.to_not change(Comment, :count)
      end

      it 'not create comment for answer' do
        expect {
          post :create, question_id: question, answer_id: answer, comment: attributes_for(:invalid_comment), context: 'question', format: :js
        }.to_not change(Comment, :count)
      end
    end
  end
end
