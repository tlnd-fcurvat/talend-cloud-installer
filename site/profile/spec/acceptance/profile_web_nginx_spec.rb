require 'spec_helper_acceptance'

if hosts_with_role(hosts, 'web_nginx').length >= 1
  describe "profile::nginx" do
    describe "nginx" do
      it 'should provision nginx web profile' do
        pp = <<-EOS
        class { 'profile::web::nginx':
        }
        EOS

        # With the version of java that ships with pe on debian wheezy, update-alternatives
        # throws an error on the first run due to missing alternative for policytool. It still
        # updates the alternatives for java
        agent = only_host_with_role(hosts, 'web_nginx')

        apply_manifest_on(agent, pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')

        #apply_manifest(pp, :catch_changes => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')
      end


      describe package('nginx') do
        it { is_expected.to be_installed }
      end

      describe service('nginx') do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end

      describe port(80) do
        before { skip("Initial implementation. There are no virtual hosts as of now") }
        it { should be_listening }
      end

    end
  end
end
