shared_context "faye-fake", faye_fake: true do
  around(:each) { |example| PrivatePub.switch_mode(:fake, &example) }
end

shared_context "faye-test", faye_test: true do
  around(:each) { |example| PrivatePub.switch_mode(:test, &example) }
end

shared_context "faye-normal", faye_normal: true do
  around(:each) { |example| PrivatePub.switch_mode(:normal, &example) }
end
