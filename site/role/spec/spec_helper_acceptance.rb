require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker-rspec/helpers/serverspec'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = [ "Darwin", "windows" ]

unless ENV["RS_PROVISION"] == "no" or ENV["BEAKER_provision"] == "no"
  hosts.each do |host|
    unless check_for_package(host, 'git')
      install_package(host, 'git')
      install_package(host, 'epel-release')
      install_package(host, 'rubygem-bundler')
    end
    on host, 'git clone https://github.com/Talend/talend-cloud-installer.git /tmp/puppet'
    on host, 'gem install r10k'
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      on host,'cd /tmp/puppet && r10k puppetfile install'
    end
  end
end
