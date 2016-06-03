require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker-rspec/helpers/serverspec'

WORKDIR = '/tmp/puppet'

# Load shared acceptance examples
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__), 'acceptance'))
Dir[base_spec_dir.join('shared/**/*.rb')].sort.each{ |f| require f }

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..' ))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      c.host = host

      # Install puppet on hosts, and provision them with role facts
      install_puppet
      on host, 'mkdir -p /etc/facter/facts.d'
      create_remote_file host,
        '/etc/facter/facts.d/role_facts.txt',
        "puppet_role=#{host['roles'].first}\npuppet_roles=#{host['roles'].join(',')}",
        :protocol => 'rsync'

      # Deploy codebase on hosts
      rsync_to host, proj_root, WORKDIR
      on host, 'yum -y install epel-release'
      on host, 'yum -y install git rubygem-bundler ruby-augeas'
      on host, "cd #{WORKDIR} && bundle install --path=vendor/bundle --without development"
      on host, "cp -R #{WORKDIR}/hiera* /etc/puppet/"

      create_remote_file host, '/etc/facter/facts.d/packagecloud_facts.txt', "packagecloud_master_token=#{ENV['PACKAGECLOUD_MASTER_TOKEN']}", :protocol => 'rsync'
      create_remote_file host, '/etc/facter/facts.d/master_password_facts.txt', "master_password=#{ENV['PACKAGECLOUD_MASTER_TOKEN']}", :protocol => 'rsync'
      on host,"cd #{WORKDIR} && bundle exec r10k puppetfile install"
    end
  end
end
