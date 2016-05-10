# Setting up the single nexus instance
#
class profile::db::nexus {

  # puppetlabs-java
  # NOTE: Nexus requires
  class{ '::java': }

  class{ '::nexus':
    version    => '2.8.0',
    revision   => '05',
    nexus_root => '/srv', # All directories and files will be relative to this
  }

  Class['::java'] ->
  Class['::nexus']

}