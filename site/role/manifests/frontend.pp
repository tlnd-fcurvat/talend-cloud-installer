#
# TIC Frontend role
#
class role::frontend {

  require ::profile::base
  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  role::register_role { 'frontend': }

  class { '::tic::frontend': }

}
