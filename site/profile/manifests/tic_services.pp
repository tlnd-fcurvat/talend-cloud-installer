#
# TIC Services profile
#
class profile::tic_services (

  $activemq_nodes         = undef,
  $mongo_nodes            = undef,
  $zookeeper_nodes        = undef,
  $flow_execution_subnets = undef,
  $version                = undef,

) {

  require ::profile::java
  require ::profile::postgresql

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs

  profile::register_profile { 'tic_services': }

  if $activemq_nodes {
    $_activemq_nodes = regsubst($activemq_nodes, '[\s\[\]\"]', '', 'G')
  } else {
    $_activemq_nodes = $activemq_nodes
  }

  if $mongo_nodes {
    $_mongo_nodes = regsubst($mongo_nodes, '[\s\[\]\"]', '', 'G')
  } else {
    $_mongo_nodes = $mongo_nodes
  }

  if $zookeeper_nodes {
    $_zookeeper_nodes = regsubst($zookeeper_nodes, '[\s\[\]\"]', '', 'G')
  } else {
    $_zookeeper_nodes = $zookeeper_nodes
  }

  if $flow_execution_subnets {
    $_flow_execution_subnets = regsubst($flow_execution_subnets, '[\s\[\]\"]', '', 'G')
  } else {
    $_flow_execution_subnets = $flow_execution_subnets
  }

  $rt_flow_subnet_ids = split($_flow_execution_subnets, ',')

  if size($version) > 0 {
    $_version = $version;
  } else {
    $_version = 'latest'
  }

  class { '::tic::services':
    activemq_nodes    => $_activemq_nodes,
    mongo_nodes       => $_mongo_nodes,
    zookeeper_nodes   => $_zookeeper_nodes,
    rt_flow_subnet_id => $rt_flow_subnet_ids[0],
    version           => $_version,
  }

  contain ::tic::services

  # Workaround for DEVOPS-703
  file {
    ['/opt/talend', '/opt/talend/ipaas']:
        ensure => directory,
        before => Package['talend-ipaas-rt-infra']
  }

}
