#
# Sets up a server, creates databases/roles and provisions databases
#
class profile::postgresql (

  $hostname       = undef,
  $password       = undef,
  $service_enable = stopped,
  $roles          = {},

) {

  require ::profile::common::packages
  include ::profile::common::concat
  profile::register_profile { 'postgresql': }

  contain ::profile::postgresql::install
  contain ::profile::postgresql::config

}
