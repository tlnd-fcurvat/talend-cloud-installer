shared_examples 'profile::elasticsearch' do

  it_behaves_like 'profile::defined', 'elasticsearch'
  it_behaves_like 'profile::common::packages'

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe service('elasticsearch-default') do
    it { should be_running }
  end

  describe 'elasticsearch plugin list' do
    subject { command('/usr/share/elasticsearch/bin/plugin --list').stdout }
    it { should include 'cloud-aws' }
  end

  describe 'service status http request' do
    subject { command('/usr/bin/curl "http://localhost:9200/?pretty"').stdout }
    it { should include '"status": 200' }
  end

end
