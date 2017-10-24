require 'test_helper'

class QuestionsChannelTest < ActionCable::Channel::TestCase
  test "subscribes to questions stream" do
    subscribe
    assert subscription.confirmed?
    assert_equal "questions", streams.last
  end
end
