require 'rails_helper'

describe Answer do
  let(:question) { create(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe "#best_answer" do
    let!(:answer) { create(:answer, question: question, best: true) }
    let(:best_answer) { create(:answer, question: question) }

    it 'updates best answer', :aggregate_failures do
      best_answer.make_best
      expect(best_answer.reload.best).to be true
      expect(answer.reload.best).to eq false
    end
  end

  describe '.default_scope' do
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'first answer in list have best attr eq true' do
      expect(question.answers.first).to eq best_answer
    end
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
