require 'spec_helper'

describe 'ami::ecs' do
  describe package('docker-engine') do
    it { is_expected.to be_installed }
  end

  describe service('docker') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('docker-amazon-ecs-agent') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe command('/usr/sbin/lvs -o+seg_monitor -a docker') do
    its(:stdout) { should include 'monitored' }
    its(:stdout) { should include 'data_tdata' }
    its(:stdout) { should include 'data_tmeta' }
  end

  describe command('/usr/bin/lsblk -a /dev/sdb') do
    its(:stdout) { should include 'docker-data_tmeta' }
    its(:stdout) { should include 'docker-data_tdata' }
  end
end
