require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker-rspec/helpers/serverspec'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = [ "Darwin", "windows" ]
WORKDIR = '/tmp/puppet'

unless ENV["RS_PROVISION"] == "no" or ENV["BEAKER_provision"] == "no"
  hosts.each do |host|
    on host, 'yum -y install git gcc gcc-c++ ruby-devel libxslt-devel libxml2-devel rubygem-bundler'
    on host, "git clone https://github.com/Talend/talend-cloud-installer.git #{WORKDIR}"
    on host, "cd #{WORKDIR} && bundle install --path=vendor/bundle --withou development"
    on host, "cp -R #{WORKDIR}/hiera* /etc/puppet/"
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
      on host,"cd #{WORKDIR} && bundle exec r10k puppetfile install"
    end
  end
end
