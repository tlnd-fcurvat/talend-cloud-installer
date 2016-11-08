#
# TIC Services role
#
class role::tic_services_external {

  require ::profile::base
  require ::profile::tic_services
  require ::profile::tic_services_external::nginx

  role::register_role { 'tic_services_external': }

}
