require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe '#best_answer' do
    let!(:answers) { create_list(:answer, 3, question: question, best: true) }
    let(:best_answer) { create(:answer, question: question, best: false) }

    it 'should change :best' do
      best_answer.make_best
      best_answer.reload
      expect(best_answer.best).to be true
    end
    it 'should change other answer :best attr' do
      best_answer.make_best
      answers.each do |answer|
        answer.reload
        expect(answer.best).to_not be true
      end
    end
  end

  describe 'Ordering by best attr' do
    let!(:answers) { create_list(:answer, 5, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'first answer in list have best attr eq true' do
      expect(question.answers.first).to eq best_answer
    end
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
