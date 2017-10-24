require 'rails_helper'

describe QuestionsChannel do
  describe "#subscribed" do
    it "subscribes to questions stream" do
      subscribe
      expect(subscription).to be_confirmed
      expect(streams.size).to eq 1
      expect(streams).to include("questions")
    end
  end
end
