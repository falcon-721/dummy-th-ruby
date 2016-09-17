require 'rspec/expectations'

RSpec::Matchers.define :transmit_to do |channel, count = 1|
  match do |actual|
    raise ArgumentError("Supports only block") unless actual.is_a? Proc

    old_size = (ActionCable.server.pubsub.transmissions[channel] || []).size
    actual.call
    new_size = (ActionCable.server.pubsub.transmissions[channel] || []).size
    
    (new_size - old_size) == count
  end

  description do
    "transmit exactly #{count} message(s) to '#{channel}' channel"
  end

  supports_block_expectations
end
