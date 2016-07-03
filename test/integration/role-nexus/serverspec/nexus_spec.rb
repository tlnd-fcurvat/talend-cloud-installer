require 'spec_helper'

describe 'role::nexus' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::db::nexus'
end
