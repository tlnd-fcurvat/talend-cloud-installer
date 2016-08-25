#
# Zookeeper service profile
#
class profile::zookeeper (

  $zookeeper_nodes = '', # A string f.e. '[ "10.0.2.12", "10.0.2.23" ]'

) {

  require ::profile::common::packagecloud_repos
  require ::profile::java

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'zookeeper': }

  # [ "10.0.2.12", "10.0.2.23" ]
  $_zookeeper_nodes = split(regsubst($zookeeper_nodes, '[\s\[\]\"]', '', 'G'), ',')

  fail($_zookeeper_nodes)

  class { '::zookeeper':
    zookeeper_nodes => $_zookeeper_nodes
  }

}
