require 'spec_helper'

describe 'role::kafka' do
  it_behaves_like 'profile::base'
  it_behaves_like 'profile::kafka'
  it_behaves_like 'role::defined', 'kafka'
end
