require 'spec_helper'

describe 'role::management_proxy' do

  describe command('/usr/bin/curl http://localhost:8080/') do
      its(:stdout) { should include 'You Know, for Search' }
  end

end
