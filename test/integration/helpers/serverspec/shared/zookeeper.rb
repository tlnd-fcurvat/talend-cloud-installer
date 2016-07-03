shared_examples 'profile::zookeeper' do
  describe port(2181) do
    it { should be_listening }
  end

  describe command('/usr/bin/wget -O - http://127.0.0.1:8080/exhibitor/exhibitor/v1/cluster/state') do
    its(:stdout) { should include '"description":"serving"' }
  end
end
