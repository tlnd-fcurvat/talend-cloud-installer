#
# Sets up the nexus instance
#
class profile::nexus (

  $nexus_root       = '/srv',
  $nexus_nodes      = '', # A string f.e. '[ "10.0.2.12", "10.0.2.23" ]'
  $nexus_nodes_port = '8081',

) {

  require ::profile::java
  require ::profile::common::packages

  include ::nginx
  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'nexus': }

  if $::osfamily == 'RedHat'{
    selinux::boolean { 'httpd_can_network_connect':
      ensure => 'on',
    }
    selinux::boolean { 'httpd_setrlimit':
      ensure => 'on',
    }

    selinux::module { 'nginx':
      content => '
module nginx 1.0;

require {
        type httpd_t;
        type transproxy_port_t;
        class tcp_socket name_connect;
}

allow httpd_t transproxy_port_t:tcp_socket name_connect;
'
    }
  }

  class { '::nexus':
    version    => '2.8.0',
    revision   => '05',
    nexus_root => $nexus_root, # All directories and files will be relative to this
    nexus_port => $nexus_nodes_port,
  }
  contain ::nexus

  # [ "10.0.2.12:8081", "10.0.2.23:8081" ]
  $_nexus_nodes = suffix(
    unique(
      concat(
        [$::ipaddress],
        split(regsubst($nexus_nodes, '[\s\[\]\"]', '', 'G'), ',')
      )
    ),
    ":${nexus_nodes_port}"
  )

  class { 'profile::nexus::nginx':
    nexus_nodes => $_nexus_nodes,
  }

}
