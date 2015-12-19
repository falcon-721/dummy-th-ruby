require 'rails_helper'

shared_examples_for 'commentable' do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
