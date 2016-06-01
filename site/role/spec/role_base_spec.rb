require 'spec_helper_acceptance'

describe "role::base" , :if => fact('puppet_roles').split(',').include('base') do
  it_behaves_like 'puppet::appliable', 'include "role::base"'
end
