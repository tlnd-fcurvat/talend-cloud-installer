# Setting up the single nexus instance
#
class profile::db::nexus (

  $nexus_root = '/srv',

) {

  include java
  
  ensure_packages(['wget'])

  file{'/usr/lib/systemd/system/nexus.service':
    ensure  => 'present',
    content => template('profile/nexus.service.erb')
  }

  class{ '::nexus':
    version    => '2.8.0',
    revision   => '05',
    nexus_root => $nexus_root, # All directories and files will be relative to this
  }

  File['/usr/lib/systemd/system/nexus.service'] ->
  Class['::java'] ->
  Class['::nexus']

}
