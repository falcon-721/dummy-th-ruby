require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }

  context "notifications" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "notifies commentable author after create" do
      expect { create(:comment, commentable: question) }
        .to change { mailbox_for(user.email).size }
    end
  end
end
