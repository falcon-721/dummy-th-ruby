require 'rspec/expectations'

RSpec::Matchers.define :transmit_to do |channel, count = 1|
  match do |actual|
    raise ArgumentError("Supports only block") unless actual.is_a? Proc

    res = false

    PrivatePub.switch_mode(:test) do
      old_size = (PrivatePub.testing_mailbox.channels[channel] || []).size
      actual.call
      new_size = (PrivatePub.testing_mailbox.channels[channel] || []).size
      res = ((new_size - old_size) == count)
    end
    res
  end

  description do
    "transmit exactly #{count} message(s) to '#{channel}' channel"
  end

  supports_block_expectations
end
