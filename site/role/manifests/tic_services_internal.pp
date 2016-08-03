#
# TIC Services role
#
class role::tic_services_internal {

  require ::profile::base
  require ::profile::tic_services

  role::register_role { 'tic_services_internal': }

}
