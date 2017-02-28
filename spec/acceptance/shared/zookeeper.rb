shared_examples 'profile::zookeeper' do

  it_behaves_like 'profile::defined', 'zookeeper'
  it_behaves_like 'profile::common::packagecloud_repos'
  it_behaves_like 'profile::common::cloudwatchlog_files', %w(
    /opt/tomcat/logs/catalina.out
  )

  describe port(2181) do
    it { should be_listening }
  end

  describe command('/usr/bin/curl http://127.0.0.1:8080/exhibitor/v1/cluster/state') do
    its(:stdout) { should match /"description":".*?"/ }
  end

  describe package('jre-jce') do
    it { should_not be_installed }
  end

  describe file('/etc/rc.d/init.d/zookeeper') do
    it { should_not exist }
  end

  describe file('/etc/init.d/zookeeper') do
    it { should_not exist }
  end

  describe service('tomcat-exhibitor') do
    it { should be_running.under('systemd') }
  end

  describe command('/usr/bin/curl -v http://127.0.0.1:8080/exhibitor/v1/config/get-state') do
    its(:stdout) { should include '"clientPort":2181' }
    its(:stdout) { should include '"connectPort":2888' }
    its(:stdout) { should include '"electionPort":3888' }
  end

end
