require 'puppetlabs_spec_helper/module_spec_helper'

describe 'profile::web::nginx' do

  let(:title) { 'profile::web::nginx' }
  let(:node) { 'rspec.stg.hrs.com' }
  let(:facts) {{  :ipaddress      => '10.42.42.42',
                  :concat_basedir => '/var/lib/puppet/concat',
                  :augeasversion => '1.4.0'
  }}


  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat',
                    :augeasversion => '1.4.0'}}

    # Test if it compiles
    it { should compile }
    it { should have_resource_count(34)}

    # Test all default params are set
    it {
      should contain_class('nginx')
      should contain_selinux__boolean('httpd_can_network_connect').with_ensure('on')
      should contain_selinux__boolean('httpd_setrlimit').with_ensure('on')
    }

  end

  describe 'building  on Debian' do
    let(:facts) { { :operatingsystem  => 'Ubuntu',
                    :lsbdistcodename  => 'trusty',
                    :lsbdistid => 'Ubuntu',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'Debian',
                    :augeasversion => '1.4.0'}}

    # Test if it compiles
    it { should compile }
    it { should have_resource_count(41)}

    # Test all default params are set
    it {
      should_not contain_class('selinux')
      should contain_class('nginx')
    }

  end

end

