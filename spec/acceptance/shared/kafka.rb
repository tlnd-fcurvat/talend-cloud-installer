shared_examples 'profile::kafka' do

  it_behaves_like 'profile::defined', 'kafka'
  it_behaves_like 'profile::common::packages'

  it_behaves_like 'profile::common::cloudwatchlog_files', %w(
      /opt/kafka/logs/server.log
      /opt/kafka/logs/state-change.log
      /opt/kafka/logs/kafka-request.log
      /opt/kafka/logs/log-cleaner.log
      /opt/kafka/logs/controller.log
      /opt/kafka/logs/kafka-authorizer.log
  )

  describe service('kafka') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  #Kafka
  describe port(9092) do
    it { should be_listening }
  end
  #JMX
  describe port(9990) do
    it { should be_listening }
  end

  describe file('/var/lib/kafka') do
    it do
      should be_mounted.with(
        :type    => 'xfs',
        :options => {
          :rw         => true,
          :noatime    => true,
          :nodiratime => true,
          :noexec     => true
        }
      )
    end
  end

  describe 'Log4j configuration' do
    subject { file('/opt/kafka/config/log4j.properties').content }
    it { should include 'managed by Puppet' }
  end

  describe 'Log cleaning' do
    subject { file('/etc/cron.daily/kafka').content }
    it { should include 'managed by Puppet' }
    it { should include '/opt/kafka/logs' }
    it { should include '-delete' }
  end

   begin
     Facter.zookeeper_nodes
   rescue
     Facter.loadfacts()
   end

  if Facter.value('zookeeper_nodes')
    zookeepernodes = ''
    Facter.value('zookeeper_nodes').gsub(/[\s\[\]\"]/, '').split(',').each { |zoonode|
      zookeepernodes += zoonode + ':2181,'
    }
    #remove last ','
    zookeepernodes.chop!
  else
    zookeepernodes = 'localhost:2181'
  end

  #Verifying topics creation
  describe "Verifying topic creation on zookeeper '" + zookeepernodes + "'" do
    subject { command('/opt/kafka/bin/kafka-topics.sh --list --zookeeper "'+ zookeepernodes + '"').stdout }
    it { should include 'tpsvclogs' }
    it { should include 'zipkin' }
    it { should include 'dispatcher' }
    it { should include 'container-manager' }
    it { should include 'container-events' }
  end
end
