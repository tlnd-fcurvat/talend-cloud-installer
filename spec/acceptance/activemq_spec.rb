require 'spec_helper'

describe 'role::activemq' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::postgresql', 'ams', %w(amqsec_rights amsaccounts)
  it_behaves_like 'profile::activemq'
  it_behaves_like 'role::defined', 'activemq'
end
