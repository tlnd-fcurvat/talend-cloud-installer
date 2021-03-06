require 'spec_helper'

describe 'role::management_proxy' do

  describe command('/usr/bin/curl -v http://localhost:8080/') do
    its(:stdout) { should_not include 'You Know, for Search' }
    its(:stdout) { should include 'HTTP/1.1 401 Unauthorized' }
  end

  describe command('/usr/bin/curl -v -u "kibana:mypassword" http://localhost:8080/') do
    its(:stdout) { should include 'You Know, for Search' }
    its(:stdout) { should include 'HTTP/1.1 200 OK' }
  end

  describe file('/etc/nginx/.htpasswd') do
    it { should be_file }
    its(:content) { should include 'kibana:' }
  end

  describe file('/etc/nginx/sites-available/es-sys.conf') do
    its(:content) { should include 'proxy_pass_request_headers off;' }
  end

end
