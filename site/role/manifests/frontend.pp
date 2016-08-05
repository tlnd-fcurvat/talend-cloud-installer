#
# TIC Frontend role
#
class role::frontend {

  require ::profile::base
  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs
  include ::profile::web::nginx

  role::register_role { 'frontend': }

  class { '::tic::frontend': }

}
