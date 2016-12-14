#
# TIC Services profile
#
class profile::tic_services (

  $activemq_nodes               = undef,
  $mongo_nodes                  = undef,
  $zookeeper_nodes              = undef,
  $nexus_nodes                  = undef,
  $nexus_nodes_port             = '8081',
  $flow_execution_subnets       = undef,
  $version                      = undef,
  $cms_nexus_url                = undef,
  $custom_resources_bucket_data = undef,
  $frontend_host                = undef,
  $confirm_email_external_url   = undef,

) {

  require ::profile::java
  require ::profile::postgresql

  include ::profile::common::concat
  include ::profile::common::cloudwatchlogs
  include ::nginx

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

  if $cms_nexus_url =~ /.*nexus$/ {
    $_cms_nexus_url = $cms_nexus_url
  } else {
    $_cms_nexus_url = "${cms_nexus_url}/nexus"
  }

  $nexus_url_scheme = url_parse($_cms_nexus_url, 'scheme')
  $nexus_url_host = url_parse($_cms_nexus_url, 'host')
  $nexus_url_port = url_parse($_cms_nexus_url, 'port')
  $nexus_url_path = url_parse($_cms_nexus_url, 'path')
  $__cms_nexus_url = "${nexus_url_scheme}://{{username}}:{{password}}@${nexus_url_host}:${nexus_url_port}${nexus_url_path}/content/repositories/{{accountid}}@id={{accountid}}.release,${nexus_url_scheme}://{{username}}:{{password}}@${nexus_url_host}:${nexus_url_port}${nexus_url_path}/content/repositories/{{accountid}}-snapshots@snapshots@id={{accountid}}.snapshot"

  if $custom_resources_bucket_data {
    $_custom_resources_bucket_data = split(regsubst($custom_resources_bucket_data, '[\s\[\]\"]', '', 'G'), ',')

    $cr_bucket_name       = $_custom_resources_bucket_data[0]
    $cr_object_key_prefix = $_custom_resources_bucket_data[1]
  } else {
    $cr_bucket_name       = undef
    $cr_object_key_prefix = undef
  }

  if $confirm_email_external_url {
    $_confirm_email_external_url = $confirm_email_external_url
  } elsif size($frontend_host) > 0 {
    $_confirm_email_external_url = "${frontend_host}/#/signup/login?trialKey="
  } else {
    $_confirm_email_external_url = undef
  }

  class { '::tic::services':
    activemq_nodes             => $_activemq_nodes,
    mongo_nodes                => $_mongo_nodes,
    nexus_nodes                => $_nexus_nodes,
    cms_nexus_url              => $__cms_nexus_url,
    zookeeper_nodes            => $_zookeeper_nodes,
    rt_flow_subnet_id          => $rt_flow_subnet_ids[0],
    version                    => $_version,
    dispatcher_nexus_url       => $_cms_nexus_url,
    cr_bucket_name             => $cr_bucket_name,
    cr_object_key_prefix       => $cr_object_key_prefix,
    confirm_email_external_url => $_confirm_email_external_url
  }

  contain ::tic::services

  # Workaround for DEVOPS-703
  file {
    ['/opt/talend', '/opt/talend/ipaas']:
        ensure => directory,
        before => Package['talend-ipaas-rt-infra']
  }

}
