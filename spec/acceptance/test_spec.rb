require 'spec_helper'

describe 'role::test' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::common::packages', %w(ipaas-rt-integration-test)
  it_behaves_like 'role::defined', 'test'

  describe package('ipaas-rt-integration-test') do
    it { should be_installed }
  end

  describe command('/usr/bin/pip show invoke') do
    its(:exit_status) { should eq 0 }
  end
end
