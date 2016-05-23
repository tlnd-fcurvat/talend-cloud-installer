require 'spec_helper_acceptance'

describe "role::web", :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do


  context 'default install' do

    it 'should provision base role' do
      pp = <<-EOS
        class { 'role::web':
        }
      EOS

      create_remote_file hosts, '/etc/facter/facts.d/external_facts.txt', 'puppet_role=web', :protocol => 'rsync'

      # With the version of java that ships with pe on debian wheezy, update-alternatives
      # throws an error on the first run due to missing alternative for policytool. It still
      # updates the alternatives for java
      apply_manifest(pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules')

    end

    describe package('nginx') do
      it { is_expected.to be_installed }
    end

    describe service('nginx') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(80) do
      it { should be_listening }
    end

    it 'should have java process with correct arguments' do
      expect(command('pgrep -a java').stdout).to match /\/opt\/apache-tomcat\/tomcat7\//
    end

    describe port(8080) do
      it { should be_listening }
    end



  end
end
