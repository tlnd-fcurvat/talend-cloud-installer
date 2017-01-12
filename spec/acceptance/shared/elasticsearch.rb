shared_examples 'profile::elasticsearch' do

  it_behaves_like 'profile::defined', 'elasticsearch'
  it_behaves_like 'profile::common::packages'
  it_behaves_like 'profile::common::cloudwatchlog_files', %w(/var/log/elasticsearch/default/tic.log)

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
    it { should match /"status"\s+:\s+200/ }
  end

  describe 'elasticsearch cluster setup' do
    subject { file('/etc/elasticsearch/default/elasticsearch.yml').content }
    it { should include 'discovery.type: ec2' }
    it { should include 'discovery.ec2.groups: sg-889900ff' }
    it { should include 'cluster.name: tic' }
  end

  describe file('/usr/share/elasticsearch/data') do
    it do
      should be_mounted.with(
        :type    => 'xfs',
        :options => {
          :rw         => true,
          :noatime    => true,
          :nodiratime => true
        }
      )
    end
  end

end
