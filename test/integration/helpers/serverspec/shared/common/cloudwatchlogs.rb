shared_examples 'profile::common::cloudwatchlogs' do

  describe service('awslogs') do
    it { should be_enabled }
    it { should be_running }

    describe 'configuration [/etc/awslogs/awslogs.conf]' do
      subject { file('/etc/awslogs/awslogs.conf').content }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/audit\/audit.log\]/ }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/messages\]/ }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/secure\]/ }
    end

    describe 'log [/var/log/awslogs.log]' do
      subject { file('/var/log/awslogs.log').content }
      it { should_not include 'ERROR:' }
    end
  end

end
