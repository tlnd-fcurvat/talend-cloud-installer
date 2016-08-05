# -*- mode: puppet -*-
# vi: set ft=puppet
#
# === Authors
# Andreas Heumaier <andreas.heumaier@nordcloud.com>
#
class profile::web::nginx {

  require ::nginx

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile{ 'nginx': }

  if $::osfamily == 'RedHat'{
    selinux::boolean{ 'httpd_can_network_connect':
      ensure => 'on',
    }
    selinux::boolean{ 'httpd_setrlimit':
      ensure => 'on',
    }
  }

}
