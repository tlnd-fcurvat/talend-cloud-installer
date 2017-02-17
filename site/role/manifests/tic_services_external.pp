#
# TIC Services role
#
class role::tic_services_external {

  require ::profile::base
  include ::profile::common::hosts
  require ::profile::tic_services

  role::register_role { 'tic_services_external': }

}
