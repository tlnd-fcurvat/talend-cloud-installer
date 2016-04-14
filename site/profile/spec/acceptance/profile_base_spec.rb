require 'spec_helper_acceptance'

describe "profile", :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe "base" do
    it 'should provision base role' do
      pp = <<-EOS
        class { 'profile::base':
        }
      EOS

      # With the version of java that ships with pe on debian wheezy, update-alternatives
      # throws an error on the first run due to missing alternative for policytool. It still
      # updates the alternatives for java
      apply_manifest(pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')

      apply_manifest(pp, :catch_changes => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules', :hiera_config => '/tmp/puppet/hiera.yaml')
    end
  end
end
