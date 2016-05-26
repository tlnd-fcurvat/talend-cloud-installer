require 'spec_helper_acceptance'

#if hosts_with_role(hosts, 'base').length >= 1
  describe "profile::base" do

    context "on profile::base" do
      it 'should provision base profile' do
        pp = <<-EOS
        class { 'profile::base':
        }
        package{'syncope':
          ensure => present,
        }
        EOS

        # With the version of java that ships with pe on debian wheezy, update-alternatives
        # throws an error on the first run due to missing alternative for policytool. It still
        # updates the alternatives for java
        agent = only_host_with_role(hosts, 'base')

        apply_manifest_on(agent, pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')

        apply_manifest_on(agent, pp, :catch_changes => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')
      end

      context 'should have base rofile prvisioned' do

        describe package('syncope') do
          it { is_expected.to be_installed }
        end

        describe package('aws-sdk') do
          it { is_expected.to be_installed }
        end
      end
    end
  end
#end