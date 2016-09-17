shared_context "cable-async", cable: true do
  around(:each) do |example|
    require 'action_cable/subscription_adapter/async'
    server = ActionCable.server
    test_adapter = ActionCable::SubscriptionAdapter::Async.new(server)
    was_adapter = server.pubsub

    server.instance_variable_set(:@pubsub, test_adapter)
    example.run
    server.instance_variable_set(:@pubsub, was_adapter)
  end
end
