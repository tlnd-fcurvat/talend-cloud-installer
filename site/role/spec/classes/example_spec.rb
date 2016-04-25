require 'puppetlabs_spec_helper/module_spec_helper'

describe 'role::example' do

  let(:title) { 'role::example' }
  let(:node) { 'rspec.datapwn.com' }
  let(:facts) {{  :ipaddress      => '10.42.42.42',
                  :concat_basedir => '/var/lib/puppet/concat',
                  :osfamily       => 'RedHat',
                  :augeasversion => '1.4.0'}}

  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat',
                    :augeasversion => '1.4.0',
                    :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'}}


    context 'with defaults for all parameters' do

      # Test if it compiles
      it { should compile }
      it { should have_resource_count(73)}

      # Test all default params are set
      it {
        should contain_class('role::example')
        should contain_class('profile::base')
        should contain_class('profile::web::nginx')
        should contain_class('profile::web::tomcat')
        should contain_class('java')      }
    end

  end
end

