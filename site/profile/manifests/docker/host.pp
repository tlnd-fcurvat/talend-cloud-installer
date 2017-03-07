#
# Docker Host profile
#
class profile::docker::host (

  $resolver_ips = [],

) {

  profile::register_profile { 'docker_host': }

  sysctl {
    'net.ipv4.conf.all.route_localnet':
      value => '1';

    'vm.max_map_count':
      value => '262144' # this value is specific for elasticsearch services needs
  }

  if $::network_eth0 {
    $t                = split($::network_eth0, '\.')
    $default_resolver = "${t[0]}.${t[1]}.${t[2]}.2"
  } else {
    $default_resolver = []
  }

  class { '::docker':
    dns                         => concat($resolver_ips, $default_resolver),
    use_upstream_package_source => true,
    repo_opt                    => '',
    require                     => Sysctl['net.ipv4.conf.all.route_localnet', 'vm.max_map_count'],
  }

  include ::docker::images
  include ::docker::run_instance

}
