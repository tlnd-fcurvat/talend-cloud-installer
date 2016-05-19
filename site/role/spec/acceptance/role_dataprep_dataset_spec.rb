require 'spec_helper_acceptance'

describe "role::dataprep_dataset", :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'default install' do

    it 'should provision base role' do
      pp = <<-EOS
        include 'role::dataprep_dataset'
      EOS

      create_remote_file hosts, '/etc/facter/facts.d/external_facts.txt', 'puppet_role=dataprep_dataset', :protocol => 'rsync'
      apply_manifest(pp, :catch_failures => true, :modulepath => '/tmp/puppet/site:/tmp/puppet/modules')
    end

    it 'should have java process with correct arguments' do
      expect(command('pgrep -a java').stdout).to match /\/opt\/talend\/dataprep\//
    end

  end
end
