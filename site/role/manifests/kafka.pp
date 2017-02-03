#
# Kafka instance role
#
class role::kafka {

  if ($::kitchen_test) {
    #Currently, we can't easyly test multinodes with kitchen: https://github.com/chef/chef-rfc/blob/master/rfc084-test-kitchen-multi.md
    #Workaround to install zookeeper on the same host in order to make kafka working
    require role::zookeeper
  }

  include ::profile::base
  include ::profile::kafka

  role::register_role { 'kafka': }

}
