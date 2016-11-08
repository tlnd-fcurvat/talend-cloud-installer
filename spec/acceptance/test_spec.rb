require 'spec_helper'

describe 'role::test' do
  it_behaves_like 'profile::base'
  it_behaves_like 'role::defined', 'test'
end
