require 'test_helper'

class AnswersChannelTest < ActionCable::Channel::TestCase
  test "subscribes to answer stream when id provided" do
    subscribe(id: 123)
    assert subscription.confirmed?
    assert_equal "questions/123/answers", streams.last
  end

  test "rejects when no id provided" do
    subscribe
    assert subscription.rejected?
  end
end
