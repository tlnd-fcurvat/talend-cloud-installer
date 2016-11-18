#
# TIC Services profile
#
class profile::tic_services (

  $activemq_nodes         = undef,
  $mongo_nodes            = undef,
  $zookeeper_nodes        = undef,
  $nexus_nodes            = undef,
  $nexus_nodes_port       = '8081',
  $flow_execution_subnets = undef,
  $version                = undef,
  $cms_nexus_url          = undef,

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

  if $nexus_nodes {
    $_nexus_nodes_str = regsubst($nexus_nodes, '[\s\[\]\"]', '', 'G')
  } else {
    $_nexus_nodes_str = $nexus_nodes
  }

  $_nexus_nodes_arr = split($_nexus_nodes_str, ',')

  if $nexus_nodes_port {
    $_nexus_nodes = join(suffix($_nexus_nodes_arr, ":${nexus_nodes_port}"), ',')
  } else {
    $_nexus_nodes = join($_nexus_nodes_arr, ',')
  }

  if $flow_execution_subnets {
    $_flow_execution_subnets = regsubst($flow_execution_subnets, '[\s\[\]\"]', '', 'G')
  } else {
    $_flow_execution_subnets = $flow_execution_subnets
  }

  $rt_flow_subnet_ids = split($_flow_execution_subnets, ',')

  if size($version) > 0 {
    $_version = $version
  } else {
    $_version = 'latest'
  }

  class { '::tic::services':
    activemq_nodes    => $_activemq_nodes,
    mongo_nodes       => $_mongo_nodes,
    nexus_nodes       => $_nexus_nodes,
    cms_nexus_url     => $cms_nexus_url,
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
