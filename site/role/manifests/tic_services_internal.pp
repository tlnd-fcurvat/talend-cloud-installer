#
# TIC Services role
#
class role::tic_services_internal {

  require ::profile::base
  include ::profile::common::hosts
  require ::profile::tic_services
  require ::profile::amazon_ses_smtp

  role::register_role { 'tic_services_internal': }

  contain ::tic::services::init_configuration_service

}
