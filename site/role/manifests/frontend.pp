#
# TIC Frontend role
#
class role::frontend {

  require ::profile::base
  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  role::register_role { 'frontend': }

  class { 'tic::globals':
    role                    => 'frontend',
    java_xmx                => 1024,
    web_enable_test_context => false,
    web_use_ssl             => true,
    cms_node                => 'cmsnode'
  } ->
  class { 'tic': }

}
