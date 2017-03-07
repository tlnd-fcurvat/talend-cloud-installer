require 'spec_helper'

describe 'role::ecs' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::docker_host'
  it_behaves_like 'role::defined', 'ecs'

  describe docker_container('amazon-ecs-agent') do
    it { should be_running }
  end

  describe service('docker-amazon-ecs-agent') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/lib/ecs/data') do
    it do
      should be_mounted.with(
        :type    => 'xfs',
        :options => {
          :rw         => true,
          :noatime    => true,
          :nodiratime => true
        }
      )
    end
  end
end
