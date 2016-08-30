#
# Sets up the mongodb instance
#
class profile::mongodb {

  require ::profile::common::packages

  include ::profile::common::concat

  profile::register_profile { 'mongodb': }

  class { '::mongodb::server':
    verbose => true,
    auth    => true,
    bind_ip => $::ipaddress
  }

  contain ::mongodb::server
  contain ::mongodb::client

}
