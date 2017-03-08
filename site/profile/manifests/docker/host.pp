#
# Docker Host profile
#
class profile::docker::host {

  profile::register_profile { 'docker_host': }

  sysctl {
    'net.ipv4.conf.all.route_localnet':
      value => '1';

    'vm.max_map_count':
      value => '262144' # this value is specific for elasticsearch services needs
  }

  class { '::docker':
    use_upstream_package_source => true,
    repo_opt                    => '',
    require                     => Sysctl['net.ipv4.conf.all.route_localnet', 'vm.max_map_count'],
  }

  include ::docker::images
  include ::docker::run_instance

}
