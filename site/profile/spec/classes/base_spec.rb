require 'puppetlabs_spec_helper/module_spec_helper'

describe 'profile::base' do

  let(:title) { 'profile::base' }
  let(:node) { 'rspec.stg.hrs.com' }
  let(:facts) {{  :ipaddress      => '10.42.42.42',
                  :concat_basedir => '/var/lib/puppet/concat',
  }}

  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat'}}

    # Test if it compiles
    it { should compile }
    it { should have_resource_count(20)}

    # Test all default params are set
    it {
      should contain_class('profile::base')
      should contain_class('stdlib')
      should contain_class('selinux')
      should contain_class('java')
    }

    context 'on AWS ' do
      let(:facts) { { :operatingsystem  => 'CentOS',
                      :lsbdistcodename  => 'trusty',
                      :concat_basedir   => '/var/lib/puppet/concat',
                      :ec2_metadata     => '{ :some =>  \'ec2 content\'}',
                      :osfamily         => 'Redhat'}}
      it { should contain_class('awscli') }
    end
  end

  describe 'building  on Debian' do
    let(:facts) { { :operatingsystem  => 'Ubuntu',
                    :lsbdistcodename  => 'trusty',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'Debian'}}

    # Test if it compiles
    it { should compile }
    it { should have_resource_count(20)}

    # Test all default params are set
    it {
      should contain_class('profile::base')
      should contain_class('stdlib')
      should contain_class('java')
      should_not contain_class('selinux')
    }
    context 'on AWS ' do
      let(:facts) { { :operatingsystem  => 'Ubuntu',
                      :lsbdistcodename  => 'trusty',
                      :concat_basedir   => '/var/lib/puppet/concat',
                      :ec2_metadata     => '{ :some =>  \'ec2 content\'}',
                      :osfamily         => 'Debian'}}
      it { should contain_class('awscli') }
    end
  end

end

