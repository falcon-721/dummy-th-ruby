require 'rails_helper'

describe AnswersChannel do
  it "subscribes to answer stream when id provided" do
    subscribe(id: 123)
    expect(subscription).to be_confirmed
    expect(streams).to contain_exactly("questions/123/answers")
  end

  it "rejects when no id provided" do
    subscribe
    expect(subscription).to be_rejected
  end
end
