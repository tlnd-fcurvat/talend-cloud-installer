#
# Docker Host profile
#
class profile::docker_host (
  $registry_region,
  $registry_bucket,
  $registry_prefix = '',
) {
  #require puppetlabs/stdlib
  #require thias/sysctl

  profile::register_profile { 'docker_host': }

  # the dns in vpc is always the 2nd address on the network
  if is_ipv4_address($::network_eth0) {
    $t = split($::network_eth0, '\.')
    $default_resolver = "${t[0]}.${t[1]}.${t[2]}.2"
  } else {
    #vagrant mode (test)?
    warning("docker-dns not resolved, you must be in test mode (kitchen/vagrant)")
    $default_resolver = undef
  }

  sysctl {
    'net.ipv4.conf.all.route_localnet':
      value => '1';

    'vm.max_map_count':
      value => '262144'  #this value is specific for elasticsearch services needs
  }

  class { '::docker':
    dns                         => $default_resolver,
    use_upstream_package_source => true,
    require                     => Sysctl['net.ipv4.conf.all.route_localnet', 'vm.max_map_count']
  }

  #every docker host has a registry listening in localhost:5000
  docker::run {
    'registry':
      image => 'registry:2',
      ports => '127.0.0.1:5000:5000',
      env   => [
        'REGISTRY_STORAGE=s3',
        "REGISTRY_STORAGE_S3_REGION=${registry_region}",
        "REGISTRY_STORAGE_S3_BUCKET=${registry_bucket}",
        "REGISTRY_STORAGE_S3_ROOTDIRECTORY=${registry_prefix}",
      ]
  }
}
