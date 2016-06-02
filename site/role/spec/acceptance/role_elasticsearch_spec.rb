require 'spec_helper_acceptance'

describe 'role::elasticsearch', :if => fact('puppet_roles').split(',').include?('elasticsearch') do
  it_behaves_like 'puppet::appliable', 'include "role::elasticsearch"'
end
