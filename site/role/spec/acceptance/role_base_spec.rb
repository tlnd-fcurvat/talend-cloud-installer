require 'spec_helper_acceptance'

describe "role::base" , :if => fact('puppet_roles').split(',').include?('base') do
  it_behaves_like 'puppet::appliable', 'include "role::base"'


  describe file('/var/log/awslogs.log') do
    its(:content) { should match /Log group:\ \/talend\/tic\/base\/var\/log\/audit,\ log stream/ }
    its(:content) { should match /Log group:\ \/talend\/tic\/base\/var\/log\/messages,\ log stream/ }
    its(:content) { should match /Log group:\ \/talend\/tic\/base\/var\/log\/secure,\ log stream/ }
    its(:content) { should_not match /ERROR:/ }
  end

end
