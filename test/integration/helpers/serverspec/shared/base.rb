shared_examples 'profile::base' do

  %w(epel talend_other talend_thirdparty).each do |repo|
    describe yumrepo(repo) do
      it { should exist }
      it { should be_enabled }
    end
  end

  describe package('epel-release') do
    it { should be_installed }
  end

  %w(hiera-eyaml hiera-eyaml-kms aws-sdk package_cloud).each do |p|
    describe package(p) do
      it { should be_installed.by('gem') }
    end
  end

  describe file('/etc/sysconfig/puppetProfile') do
    its(:content) { should include 'base' }
  end

  describe service('awslogs') do
    it { should be_enabled }
    it { should be_running }

    describe 'configuration' do
      subject { file('/etc/awslogs/awslogs.conf').content }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/audit\/audit.log\]/ }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/messages\]/ }
      it { should match /\[\/talend\/tic\/.*?\/var\/log\/secure\]/ }
    end

    describe 'log' do
      subject { file('/var/log/awslogs.log').content }
      it { should_not include 'ERROR:' }
    end
  end

end
