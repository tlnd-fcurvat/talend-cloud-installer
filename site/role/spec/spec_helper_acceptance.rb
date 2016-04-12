require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker-rspec/helpers/serverspec'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = [ "Darwin", "windows" ]

unless ENV["RS_PROVISION"] == "no" or ENV["BEAKER_provision"] == "no"
  hosts.each do |host|
    if host['platform'] =~ /sles-1/i ||  host['platform'] =~ /solaris-1/i
      get_stdlib = <<-stdlib
      package{'wget':}
      exec{'download':
        command => "wget -P /root/ https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.3.2.tar.gz --no-check-certificate",
        path => ['/opt/csw/bin/','/usr/bin/']
      }
      stdlib
      apply_manifest_on(host, get_stdlib)
      # have to use force otherwise it checks ssl cert even though it is a local file
      on host, puppet('module install /root/puppetlabs-stdlib-4.3.2.tar.gz --force')
    else
      on host, puppet("module install puppetlabs-stdlib")
      # For test support
      #on host, puppet("module install puppetlabs-apt")
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    hosts.each do |host|
      unless check_for_package(host, 'git')
        install_package(host, 'git')
        install_package(host, 'bundler')
      end
      on host, '/usr/bin/git clone https://github.com/Talend/talend-cloud-installer.git /tmp '
      on host, 'cd /tmp/talend-cloud-installer'
      on host, 'bundle install --path=vendor/bundle'
      on host, 'r10k puppetfile install'
    end
  end
end
