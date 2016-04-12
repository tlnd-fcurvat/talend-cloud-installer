require 'spec_helper_acceptance'

describe "role", :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe "myrole" do
    it 'should deploy test artifact' do
      pp = <<-EOS
        class { 'deploy':
          service_name => 'soap-service',
          service_version => '0.1.7'
        }
      EOS

      # With the version of java that ships with pe on debian wheezy, update-alternatives
      # throws an error on the first run due to missing alternative for policytool. It still
      # updates the alternatives for java
      apply_manifest(pp, :catch_failures => true)

      apply_manifest(pp, :catch_changes => true)
    end
  end
end
