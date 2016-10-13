#
# TIC Frontend role
#
class role::frontend {

  require ::profile::base
  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs
  include ::profile::web::nginx

  contain ::profile::tic_frontend

  role::register_role { 'frontend': }

}
