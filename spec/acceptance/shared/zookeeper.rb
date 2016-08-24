shared_examples 'profile::zookeeper' do

  it_behaves_like 'profile::defined', 'zookeeper'
  it_behaves_like 'profile::common::packagecloud_repos'
  it_behaves_like 'profile::common::cloudwatchlog_files', %w(
    /opt/tomcat/logs/catalina.out
  )

  describe port(2181) do
    it { should be_listening }
  end

  describe command('/usr/bin/wget -O - http://127.0.0.1:8080/exhibitor/v1/cluster/state') do
    its(:stdout) { should match /"description":"(serving|latent)"/ }
  end

end
