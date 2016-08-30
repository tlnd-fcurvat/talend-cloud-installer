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

  class { '::activemq': } ->
  class { '::profile::postgresql::provision': }

  contain ::activemq

  # prevent postgres provisioning on all the nodes except one: ActiveMQ-A
  # this should be replaced with more sophisticated solution in the future
  $ec2_userdata = pick($::ec2_userdata, '')
  if $ec2_userdata =~ /InstanceA/ {
    contain ::profile::postgresql::provision
  }

}
