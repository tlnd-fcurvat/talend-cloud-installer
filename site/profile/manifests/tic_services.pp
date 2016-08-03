#
# TIC Services profile
#
class profile::tic_services {

  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'tic_services': }

  contain ::tic::services

  # Workaround for DEVOPS-703
  file {
    ['/opt/talend', '/opt/talend/ipaas']:
        ensure => directory,
        before => Package['talend-ipaas-rt-infra']
  }
}
