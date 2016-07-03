shared_examples 'profile::elasticsearch' do
  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe service('elasticsearch-default') do
    it { should be_running }
  end

  describe command('/usr/share/elasticsearch/bin/plugin --list') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should include 'cloud-aws' }
  end

  describe command('/usr/bin/curl "http://localhost:9200/?pretty"') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should include '"status" : 200' }
  end
end
