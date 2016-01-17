module PrivatePubTesting
  class Mailbox
    attr_reader :channels

    def initialize
      @channels = {}
    end

    def push(channel, data)
      (@channels[channel] ||= []) << data
    end
  end

  def publish_to(channel, data)
    return if fake?
    return testing_mailbox.push(channel, data) if test?
    super
  end

  %i(fake test normal).each do |mode|
    define_method "#{mode}!" do |&block|
      switch_mode(mode, &block)
    end

    define_method "#{mode}?" do
      testing_mode == mode
    end
  end

  def switch_mode(mode)
    return @testing_mode = mode unless block_given?

    old_mode = testing_mode
    @testing_mode = mode
    yield
    @testing_mode = old_mode
  end

  def testing_mode
    @testing_mode ||= :normal
  end

  def testing_mailbox
    @testing_mailbox ||= Mailbox.new
  end
end

PrivatePub.singleton_class.send(:prepend, PrivatePubTesting)
