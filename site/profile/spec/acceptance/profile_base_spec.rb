require 'spec_helper_acceptance'

on hosts_with_role(hosts, 'base') do

  describe "profile::base" do

    context "on profile::base" do
      it 'should provision base profile' do
        pp = <<-EOS
        class { 'profile::base':
        }
        EOS

        # With the version of java that ships with pe on debian wheezy, update-alternatives
        # throws an error on the first run due to missing alternative for policytool. It still
        # updates the alternatives for java
        agent = only_host_with_role(hosts, 'base')

        apply_manifest_on(agent, pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')

        #apply_manifest_on(agent, pp, :catch_changes => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')
      end

      context 'should have base profile provisioned' do

        describe yumrepo('epel') do
          it { should exist }
          it { should be_enabled }
        end

        describe yumrepo('talend_other') do
          it { should exist }
          it { should be_enabled }
        end

        describe yumrepo('talend_thirdparty') do
          it { should exist }
          it { should be_enabled }
        end

        describe package('aws-sdk') do
          it { is_expected.to be_installed.by('pip') }
        end
      end
    end
  end
end