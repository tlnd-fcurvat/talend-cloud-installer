require 'spec_helper'

describe 'role::ecs' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::docker_host'
  it_behaves_like 'role::defined', 'ecs'

  describe docker_container('amazon-ecs-agent') do
    it { should be_running }
  end
end
