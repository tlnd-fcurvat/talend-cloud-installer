#
# ActiveMQ service profile
#
class profile::activemq {

  require ::profile::common::packagecloud_repos
  require ::profile::java
  require ::profile::postgresql

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'activemq': }

  contain ::activemq

}
