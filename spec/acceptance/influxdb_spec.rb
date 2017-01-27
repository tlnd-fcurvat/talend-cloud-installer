require 'spec_helper'

describe 'role::influxdb' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::influxdb'
  it_behaves_like 'role::defined', 'influxdb'
end
