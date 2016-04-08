require 'puppetlabs_spec_helper/module_spec_helper'

describe 'role::example' do

  let(:title) { 'role::example' }
  let(:node) { 'rspec.stg.hrs.com' }
  let(:facts) {{  :ipaddress      => '10.42.42.42',
                  :concat_basedir => '/var/lib/puppet/concat',
                  :osfamily       => 'RedHat'}}

  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat'}}


    context 'with defaults for all parameters' do

      # Test if it compiles
      it { should compile }
      it { should have_resource_count(20)}

      # Test all default params are set
      it {
        should contain_class('role::example')
        should contain_class('profile::base')
      }
    end

  end
end

